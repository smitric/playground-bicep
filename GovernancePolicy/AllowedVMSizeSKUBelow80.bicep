targetScope = 'subscription'

param policyDefinitionId string = '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'

resource AllowedVMSizesAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Allowed VM SKU sizes'
  scope: subscription()
  properties: {
    policyDefinitionId: policyDefinitionId
    parameters: {
      listOfAllowedSKUs: {
        value: [
          'B1s'
          'B1ls'
          'B2s'
          'B2ms'
          'DS1_V2'
          'A1_v2'
          'A2_v2'
          'D1_v2'
          'A0'
          'A0_Basic'
          'A1'
          'A1_Basic'
          'A2_Basic'
          'D1'
          'DS1'
        ]
      }
    }
  }
}
