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
          'Basic_A0'
          'Basic_A1'
          'Basic_A2'
          'Basic_A3'
          'Basic_A4'
          'Basic_A1_v2'
          'Basic_A2_v2'
          'A0_Basic'
          'A1'
          'A1_Basic'
          'A2'
          'A2_Basic'
          'A2_v2'
          'B1s'
          'B1ls'
          'Standard_B1s'
          'Standard_B1ls'
          'Standard_B1ms'
          'Standard_B2s'
          'Standard_B2ms'
          'Standard_A1_v2'
          'Standard_A2_v2'
          'Standard_A2m_v2'
          'Standard_D2as_v5'
          'Standard_D2ads_v5'
          'Standard_D2a_v4'
          'Standard_D2as_v4'
          'Standard_D2d_v5'
          'Standard_D2ds_v5'
          'Standard_D2_v5'
          'Standard_D2s_v5'
          'Standard_DC2ads_v5'
          'Standard_DC2as_v5'
          'Standard_D2_v4'
          'Standard_D2s_v4'
          'Standard_D2_v3'
          'Standard_D2s_v3'
          'Standard_DC1s_v3'
          'Standard_DC1ds_v3'
          'Standard_D1_v2'
          'Standard_DS1_v2'
          'Standard_DC1s_v2'
          'Standard_F2s_v2'
          'Standard_F1'
          'Standard_F2'
          'Standard_E2as_v5'
          'Standard_E8s_v3'
          'Standard_E8s_v4'
          'E8s_v3'
          'E8s_v4'
        ]
      }
    }
  }
}
