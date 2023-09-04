@description('Specifies the location for resources.')
param location string = 'westeurope'

targetScope = 'subscription'

param policyDefinitionId string = '/providers/Microsoft.Authorization/policyDefinitions/cd3aa116-8754-49c9-a813-ad46512ece54'

resource pillarAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
    name: 'Inherit a Pillar tag from the resource group'
    scope: subscription()
    location: location
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        policyDefinitionId: policyDefinitionId
        parameters: {
            tagName: {
                value: 'Pillar'
            }
        }
    }
}

resource usageAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
    name: 'Inherit a Usage tag from the resource group'
    scope: subscription()
    location: location
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        policyDefinitionId: policyDefinitionId
        parameters: {
            tagName: {
                value: 'Usage'
            }
        }
    }
}

resource userRoleAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
    name: 'Inherit a user Role tag from the resource group'
    scope: subscription()
    location: location
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        policyDefinitionId: policyDefinitionId
        parameters: {
            tagName: {
                value: 'Role'
            }
        }
    }
}
