function ValidateAndDeleteResourceGroup {
    param(
        [Parameter (Mandatory = $true)] [string]$rgName,
        [Parameter (Mandatory = $true)] [boolean]$budgetExceeded,
        [Parameter (Mandatory = $true)] [boolean]$dateExceeded
    )

    if ($budgetExceeded -eq $False -And $dateExceeded -eq $False) {
        Write-Host "########## $rgName did not exceed the budget limit or is younger than 30 days ##########"
        Write-Host "########## No action will be taken ##########"
        return $False
        Break
    }

    Write-Host "Either budget limit has been exceeded or the resource group $rgName is older than 30 days"
    Write-Warning "########## $rgName will be deleted ##########"
    Write-Host "First delete the budget"

    $auth = Get-AzAccessToken

    $authHeader = $auth.token

    $deleteBudgetUrl = "https://management.azure.com/subscriptions/717f701d-a8d2-4255-ab08-d943cc8e8914/resourceGroups/$rgName/providers/Microsoft.Consumption/budgets/budgetAlerts?api-version=2023-03-01"

    Invoke-WebRequest $deleteBudgetUrl -Method Delete -Headers @{"Authorization" = "Bearer $authHeader" }

    Write-Host "Deleting the resource group now..."

    Remove-AzResourceGroup -Name $rgName -Force

    return $True
}
