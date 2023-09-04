targetScope = 'subscription'

param policyDefinitionId string = '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'

resource allowedLocationsAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Allowed locations'
  scope: subscription()
  properties: {
    policyDefinitionId: policyDefinitionId
    parameters: {
      listOfAllowedLocations: {
        value: [
          'westeurope'
        ]
      }
    }
  }
}
