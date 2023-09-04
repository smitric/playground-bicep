targetScope = 'subscription'

@description('Playgroud Subscription Id')
param playgroudSubscriptionId string = '717f701d-a8d2-4255-ab08-d943cc8e8914'

@description('Resource group name where the function will be created.')
param rgName string = 'pers-admin-rg'

@description('The name of the function app that you wish to create.')
param appName string = 'resource-group-provisioner'

@description('The name of the storage account to listen for changes')
param storageAccountTrigger string = 'sapersadmin01'

@description('The resource group name of the storage account to listen for changes')
param storageAccountResourceGroupTrigger string = rgName

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' existing = {
  name: rgName
}

module function './function.bicep' = {
  name: 'appDeployment'
  scope: rg
  params: {
    appName: appName
    location: rg.location
    storageAccountTrigger: storageAccountTrigger
  }
}

var functionAppPrincipalId = function.outputs.functionAppPrincipalId

module roleAssignmentToAccessFile './roleAssignmentToAccessFile.bicep' = {
  name: 'roleAssignmentToAccessFile'
  scope: resourceGroup(storageAccountResourceGroupTrigger)
  params: {
    appName: appName
    functionAppPrincipalId: functionAppPrincipalId
    storageAccountTrigger: storageAccountTrigger
  }
}

module roleAssignmentToSubscription './roleAssignmentToSubscription.bicep' = {
  name: 'roleAssignmentToSubscription'
  scope: subscription(playgroudSubscriptionId)
  params: {
    appName: appName
    functionAppPrincipalId: functionAppPrincipalId
  }
}

module playgroundOwnerRole './playgroundOwnerRole.bicep' = {
  name: 'playgroundOwnerRole'
  scope: subscription(playgroudSubscriptionId)
}

@description('The identity Id assigned to the function')
output functionAppPrincipalId string = functionAppPrincipalId

@description('Playground Resource Group Owner role id')
output playgroundOwnerRoleId string = playgroundOwnerRole.outputs.playgroundOwnerRoleId
