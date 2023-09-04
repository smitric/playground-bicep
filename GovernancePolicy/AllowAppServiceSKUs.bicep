targetScope = 'subscription'

param policyDefinitionId string = '/subscriptions/717f701d-a8d2-4255-ab08-d943cc8e8914/providers/Microsoft.Authorization/policyDefinitions/3a1c9dd9-90bd-4012-bb07-e17ab369a514'

resource AllowAppServiceSKUs 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Allowed App Service SKUs'
  scope: subscription()
  properties: {
    policyDefinitionId: policyDefinitionId
    parameters: {
      listOfAllowedSKUs: {
        value: [
            'F1'
            'D1'
            'B1'
            'B2'
            'B3'
	    'S1'
            'S2'
	    'S3'
        ]
      }
    }
  }
}
