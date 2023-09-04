. "$PSScriptRoot\inviteNewUser.ps1"
. "$PSScriptRoot\deployment.ps1"
. "$PSScriptRoot\sendEmail.ps1"
. "$PSScriptRoot\sendErrorMessageToGoogleChat.ps1"

function ResourceGroupExists {
    param(
        [Parameter (Mandatory = $true)] [String]$resourceGroupName
    )
    
    Get-AzResourceGroup -Name $resourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue

    return (-Not $notPresent )
}

function global:CreateResourceGroupAndDependencies {
    param(
        [Parameter (Mandatory = $true)] [String]$email,
        [Parameter (Mandatory = $true)] [String]$userName,
        [Parameter (Mandatory = $true)] [String]$pillar,
        [Parameter (Mandatory = $true)] [String]$usage,
        [Parameter (Mandatory = $true)] [String]$userRole,
        [Parameter (Mandatory = $true)] [String]$invocationId
    )

    $ErrorActionPreferenceBeforeChange = $ErrorActionPreference
    try {
        $ErrorActionPreference = "Stop"

        PrivateCreateResourceGroupAndDependencies -Email $email -UserName $userName -Pillar $pillar -Usage $usage -UserRole $userRole
    }
    catch {
        $message = $_
        $scriptStackTrace = $_.ScriptStackTrace
        Write-Warning "An error occurred!"
        Write-Warning "Error: '$message'"
        Write-Warning "ScriptStackTrace: '$scriptStackTrace'"
        try {
            SendMessageToGoogleChat -RequestorEmail $email -ErrorMessage $message -InvocationId $invocationId
        }
        catch {
            Write-Host ""
            Write-Warning "Error sending error message: '$_'"
        }
    }
    $ErrorActionPreference = $ErrorActionPreferenceBeforeChange
}

function PrivateCreateResourceGroupAndDependencies {
    param(
        [Parameter (Mandatory = $true)] [String]$email,
        [Parameter (Mandatory = $true)] [String]$userName,
        [Parameter (Mandatory = $true)] [String]$pillar,
        [Parameter (Mandatory = $true)] [String]$usage,
        [Parameter (Mandatory = $true)] [String]$userRole
    )
    $jsonObj = Get-AzADUser -Mail $email -Select "id,displayName" -ErrorAction Stop | ConvertFrom-Json 

    if ($null -eq $jsonObj) {
        Write-Warning "User not found for email '$email'."

        $displayName = $userName
        $objectId = InviteUser -UserEmail $email -UserName $userName
    }
    else {
        $displayName = $jsonObj[0].displayName
        $objectId = $jsonObj[0].id
    }

    $resourceGroupName = ($displayName + "-rg").ToLower().Replace(" ", "_")


    Write-host "Display name in Azure AD: $displayName"
    Write-host "Resource group name: $resourceGroupName"

    $rgExists = ResourceGroupExists -ResourceGroupName $resourceGroupName

    if ($rgExists) {
        Write-Warning "Resource group '$resourceGroupName' already exists"
        return 0
    }

    Write-host "Creating resource group for $displayName ..."
    CreateResourceGroup -ResourceGroupName $resourceGroupName -Pillar $pillar -Usage $usage -UserRole $userRole 
    Write-host "Resource group for $displayName created"

    Write-host "Setting resource group owner for $displayName ..."
    SetResourceGroupOwner -ResourceGroupName $resourceGroupName -OwnerObjectId $objectId
    Write-host "Resource group owner for $displayName defined"

    Write-host "Creating budget for $displayName ..."
    CreateResourceGroupBudget -ResourceGroupName $resourceGroupName -AlertEmail $email
    Write-host "Budget for $displayName created"

    Write-host "Sending Email to $displayName ..."
    SendEmailToUser -email $email -resourceGroupName $resourceGroupName -displayName $displayName
    Write-host "Email to $displayName has been sent"
}
