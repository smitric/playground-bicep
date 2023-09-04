targetScope = 'subscription'

resource playgroundOwnerRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  properties: {
    roleName: 'Playground Resource Group Owner'
    type: 'CustomRole'
    description: 'This role give the necessary permissions to a Resource group where the player can create the Resources. '
    assignableScopes: [
      subscription().id
    ]
    permissions: [
      {
        actions: [
          '*'
        ]

        notActions: [
          'Microsoft.Resources/tags/write'
          'Microsoft.Resources/tags/delete'
          'Microsoft.CostManagement/alerts/write'
          'Microsoft.Resources/subscriptions/resourceGroups/write'
        ]

        dataActions: []

        notDataActions: []
      }
    ]
  }
  name: 'd97c5aba-cb8e-4489-8542-38d4a3b63117'
}

@description('Playground Resource Group Owner role id')
output playgroundOwnerRoleId string = playgroundOwnerRole.id
