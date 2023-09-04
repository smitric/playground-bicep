targetScope = 'resourceGroup'

param ownerObjectId string

var principalId = ownerObjectId

var playgroundOwnerRoleId = 'd97c5aba-cb8e-4489-8542-38d4a3b63117'

resource roleAuthorization 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, playgroundOwnerRoleId)

  scope: resourceGroup()
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', playgroundOwnerRoleId)
    principalType: 'User'
  }
}
