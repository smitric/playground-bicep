targetScope = 'subscription'

resource policy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'require-tag-and-its-value-on-resource-groups-many-values-allowed'
  properties: {
    displayName: 'Require a tag and its value (one of many) on resource groups'
    description: 'Enforces a required tag and its value on resource groups. The value can be one of many.'
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'Tags'
    }

    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Resources/subscriptions/resourceGroups'
          }
          {
            not: {
              field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
              in: '[parameters(\'allowedTagValues\')]'
            }
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }

    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Tag Name'
          description: 'Name of the tag, such as \'Pillar\''
        }
      }

      allowedTagValues: {
        type: 'Array'
        metadata: {
          displayName: 'Allowed tag values'
          description: 'The list of value that can be specified for this tag'
        }
      }
    }
  }
}

resource pillarAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Require Pillar tag and its value (one of n) on resource groups'
  scope: subscription()
  properties: {
    policyDefinitionId: policy.id
    parameters: {
      tagName: {
        value: 'Pillar'
      }

      allowedTagValues: {
        value: [
          'M Cloud'
          'S Platform'
          'Innovative Tech'
          'Public Consulting'
          'Digital Impulse' ]
      }
    }
  }
}

resource usageAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Require Usage tag and its value (one of n) on resource groups'
  scope: subscription()
  properties: {
    policyDefinitionId: policy.id
    parameters: {
      tagName: {
        value: 'Usage'
      }

      allowedTagValues: {
        value: [
          'Client related activities'
          'Devoteam related activities'
          'Training / Certification related activities'
          'Other'
        ]
      }
    }
  }
}

resource userRoleAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Require Role tag and its value (one of n) on resource groups'
  scope: subscription()
  properties: {
    policyDefinitionId: policy.id
    parameters: {
      tagName: {
        value: 'Role'
      }

      allowedTagValues: {
        value: [
          'Consultant'
          'Futures'
        ]
      }
    }
  }
}
