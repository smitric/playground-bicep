targetScope = 'resourceGroup'

@description('Name of the Budget. It should be unique within a resource group.')
param budgetName string = 'budgetAlerts'

@description('The total amount of cost or usage to track with the budget')
param amount int = 150

@description('The time covered by a budget. Tracking of the amount will be reset based on the time grain.')
@allowed([
  'Monthly'
  'Quarterly'
  'Annually'
])
param timeGrain string = 'Annually'

@description('The start date must be first of the month in YYYY-MM-DD format. Future start date should not be more than three months. Past start date should be selected within the timegrain preiod.')
param startDate string = '2023-01-01'

@description('The list of email addresses to send the budget notification to when the threshold is exceeded.')
param contactEmails array = [ 'user@devoteam.com' ]

resource budget 'Microsoft.Consumption/budgets@2021-10-01' = {
  name: budgetName
  scope: resourceGroup()
  properties: {
    timePeriod: {
      startDate: startDate
    }
    timeGrain: timeGrain
    amount: amount
    category: 'Cost'
    notifications: {
      actual_GreaterThan_25_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 25
        contactEmails: contactEmails
        contactRoles: [
          'Contributor'
        ]
      }
      actual_GreaterThan_50_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 50
        contactEmails: contactEmails
        contactRoles: [
          'Contributor'
        ]
      }
      actual_GreaterThan_75_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 75
        contactEmails: contactEmails
        contactRoles: [
          'Contributor'
        ]
      }
    }
  }
}
