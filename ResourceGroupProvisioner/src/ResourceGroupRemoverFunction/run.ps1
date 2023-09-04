# Input bindings are passed in via param block.
param($Timer)

. "$PSScriptRoot\rgBudgetLimitExceeded.ps1"
. "$PSScriptRoot\getBudgetLimitPerRG.ps1"
. "$PSScriptRoot\getCurrentSpendPerRG.ps1"
. "$PSScriptRoot\validateAndDeleteResourceGroup.ps1"

Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"

$subscriptionId = (Get-AzContext).Subscription.id
$path = "/subscriptions/$subscriptionId/resourceGroups?api-version=2020-06-01&%24expand=createdTime"
$response = Invoke-AzRestMethod -Path $path

$json = $response.Content | ConvertFrom-Json
$personalRG = $json.Value 
    | Where-Object { $_.Tags.role -notmatch "Futures" }
    | Where-Object { $_.Tags.Tier -match "Personal" }

foreach ($rg in $personalRG) {
    [string] $rgName = $rg.name
    $budgetAmount = getBudgetLimitPerRG -ResourceGroupName $rgName
    $currentSpend = getCurrentSpendPerRG -ResourceGroupName $rgName
    [boolean] $budgetExceeded = ResourceGroupBudgetLimitExceeded -CurrentSpend $currentSpend -BudgetLimit $budgetAmount
    
    $cutoffDate = (get-date).AddDays(-30).Date
    [boolean] $dateExceeded = $cutoffDate -gt $rg.createdTime

    Write-Host "####################################### $rgName ####################################"
    $result = ValidateAndDeleteResourceGroup -RgName $rgName -BudgetExceeded $budgetExceeded -DateExceeded $dateExceeded
    Write-Host "####################################### $rgName ####################################"
}
