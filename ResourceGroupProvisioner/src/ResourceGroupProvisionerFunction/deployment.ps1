function CreateResourceGroup {
    param(
        [Parameter (Mandatory = $true)] [String]$resourceGroupName,
        [Parameter (Mandatory = $true)] [String]$pillar,
        [Parameter (Mandatory = $true)] [String]$usage,
        [Parameter (Mandatory = $true)] [String]$userRole
    )

    New-AzSubscriptionDeployment `
        -Name createRg `
        -Location westeurope `
        -ResourceGroupName $resourceGroupName `
        -ResourceGroupLocation westeurope `
        -Pillar $pillar `
        -Usage $usage `
        -Role $userRole `
        -TemplateFile $PSScriptRoot\rg.json
}

function SetResourceGroupOwner {
    param(
        [Parameter (Mandatory = $true)] [String]$resourceGroupName,
        [Parameter (Mandatory = $true)] [String]$ownerObjectId
    )

    New-AzResourceGroupDeployment `
        -Name assignRgOwner `
        -ResourceGroupName $resourceGroupName `
        -OwnerObjectId $ownerObjectId `
        -TemplateFile $PSScriptRoot\rgOwner.json
}

function CreateResourceGroupBudget {
    param(
        [Parameter (Mandatory = $true)] [String]$resourceGroupName,
        [Parameter (Mandatory = $true)] [String]$alertEmail
    )
    
    New-AzResourceGroupDeployment `
        -Name createRGBudget `
        -ResourceGroupName $resourceGroupName `
        -ContactEmails $alertEmail `
        -TemplateFile $PSScriptRoot\rgBudget.json
}
