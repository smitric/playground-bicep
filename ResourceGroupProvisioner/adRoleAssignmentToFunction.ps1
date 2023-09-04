
param($functionAppPrincipalId)


function AddAdRole {
    param(
        [Parameter (Mandatory = $true)] [String]$adRoleId
    )
    
    $baseUrl = "https://graph.microsoft.com/v1.0/roleManagement/directory/RoleAssignments"

    $token = $(az account get-access-token --resource=https://graph.microsoft.com --query accessToken --output tsv)
    
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Bearer $token")
    $headers.Add("Content-Type", "application/json")
    
    
    $getUrl = "$($baseUrl)?`$filter=roleDefinitionId eq '$adRoleId' and principalId eq '$functionAppPrincipalId'"
    
    $response = Invoke-RestMethod $getUrl -Method "GET" -Headers $headers
    $roleAlreadyAdded = $response.value.Length -eq 1
    if ($roleAlreadyAdded) {
        Write-host "Role $adRoleId already added."
    }
    else { 
    
        $body = "{
            `n    `"odata.type`"       : `"#microsoft.graph.unifiedRoleAssignment`",
            `n    `"principalId`"      : `"$functionAppPrincipalId`",
            `n    `"roleDefinitionId`" : `"$adRoleId`",
            `n    `"directoryScopeId`" : `"/`",
            `n}"
    
        Invoke-RestMethod $baseUrl -Method "POST" -Headers $headers -Body $body
    
        Write-host "Role $adRoleId added."
    }
}

function AddAppRole {
    param(
        [Parameter (Mandatory = $true)] [String]$appRoldeId
    )
    $graphAPI = "00000003-0000-0000-c000-000000000000"
    $sp = az ad sp show --id $graphAPI  -o json | ConvertFrom-Json
    $graphAPIId = $sp.id

    $url = "https://graph.microsoft.com/v1.0/servicePrincipals/$graphAPIId/appRoleAssignedTo"

    $token = $(az account get-access-token --resource=https://graph.microsoft.com --query accessToken --output tsv)

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Bearer $token")
    $headers.Add("Content-Type", "application/json")


    $body = "{
        `n    `"principalId`" : `"$functionAppPrincipalId`",
        `n    `"resourceId`"  : `"$graphAPIId`",
        `n    `"appRoleId`"   : `"$appRoldeId`",
        `n}"
    Try {
        Invoke-RestMethod $url -Method "POST" -Headers $headers -Body $body
    }
    Catch {
        if ($_.ErrorDetails.Message.Contains("Permission being assigned already exists on the object")) {
            Write-Host "Permission being assigned already exists on the object ($appRoldeId)"
        }
        else {
            Write-Error $_
        }
    }
}

$globalReaderRole = "f2ef992c-3afb-46b9-b7cf-a126ee74c451"
$invateUserAppRoleId = "09850681-111b-4a89-9bed-3f2cae46d706"

AddAdRole -AdRoleId $globalReaderRole

AddAppRole -AppRoldeId $invateUserAppRoleId