targetScope = 'resourceGroup'

@description('The name of the function app that you wish to create.')
param appName string

@description('The identity Id assigned to the function')
param functionAppPrincipalId string

@description('The name of the storage account to listen for changes')
param storageAccountTrigger string

resource storageAccountToListen 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountTrigger
}

var blobContribuitorRoleDefinitionId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

resource roleAssignmentsToAccessFile 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccountToListen.id, appName, blobContribuitorRoleDefinitionId)
  scope: storageAccountToListen
  properties: {
    principalId: functionAppPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', blobContribuitorRoleDefinitionId)
    principalType: 'ServicePrincipal'
  }
}
