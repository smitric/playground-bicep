targetScope = 'subscription'

param policyDefinitionId string = '/subscriptions/41e50375-b926-4bc4-9045-348f359cf721/providers/Microsoft.Authorization/policyDefinitions/3a1c9dd9-90bd-4012-bb07-e17ab369a514'

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
