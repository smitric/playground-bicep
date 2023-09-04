function getBudgetLimitPerRG {
    param(
        [Parameter (Mandatory = $true)] [String]$resourceGroupName
    )
    $subscriptionId = (Get-AzContext).Subscription.id
    $Path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Consumption/budgets/budgetAlerts?api-version=2021-10-01"
    $Response = Invoke-AzRestMethod -Path $Path

    $json = $Response.Content | ConvertFrom-Json

    return [int]$json.properties.amount

}