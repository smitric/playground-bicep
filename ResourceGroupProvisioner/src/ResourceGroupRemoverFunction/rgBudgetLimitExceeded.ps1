function ResourceGroupBudgetLimitExceeded {
    [OutputType([boolean])]
    param(
        [Parameter (Mandatory = $true)] [int]$currentSpend,
        [Parameter (Mandatory = $true)] [int]$budgetLimit
    )

    if ($currentSpend -gt $budgetLimit) {
       return $True  
    }

    return $False
}
