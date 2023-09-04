targetScope = 'subscription'

@description('The name of the function app that you wish to create.')
param appName string

@description('The identity Id assigned to the function')
param functionAppPrincipalId string

var managedApplicationContributorRoleId = '641177b8-a67a-45b9-a033-47bc880bb21e'

resource roleAssignmentsToCreateRGs 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, appName, managedApplicationContributorRoleId)
  scope: subscription()
  properties: {
    principalId: functionAppPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', managedApplicationContributorRoleId)
    principalType: 'ServicePrincipal'
  }
}

var rbacAdminRoleId = 'f58310d9-a9f6-439a-9e8d-f62e7b41a168'

resource roleAssignmentsToAssingRGOwnder 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, appName, rbacAdminRoleId)
  scope: subscription()
  properties: {
    principalId: functionAppPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', rbacAdminRoleId)
    principalType: 'ServicePrincipal'
  }
}

var costContribuitorRoleId = '434105ed-43f6-45c7-a02f-909b2ba83430'

resource roleAssignmentsToCreateRGBudget 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, appName, costContribuitorRoleId)
  scope: subscription()
  properties: {
    principalId: functionAppPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', costContribuitorRoleId)
    principalType: 'ServicePrincipal'
  }
}
