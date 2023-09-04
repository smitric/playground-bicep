targetScope = 'subscription'

@description('Specifies the location for resources.')
param location string = 'westeurope'

module policyDefinition './devoteamCustomTagPolicy.bicep' = {
  name: 'devoteamCustomTagPolicy'
}

module inheritTagsFromRGPolicyAssignment './inheritTagsFromRGPolicyAssignment.bicep' = {
  name: 'inheritTagsFromRGPolicyAssignment'

  params: {
    location: location
  }
}

module allowedLocationsPolicyAssignment './allowedLocationsPolicyAssignment.bicep' = {
  name: 'allowedLocationsPolicyAssignment'
}

module AllowAppServiceSKUs './AllowAppServiceSKUs.bicep' = {
  name: 'AllowAppServiceSKUs'
}

module AllowedVMSizesAssignment './AllowedVMSizeSKUBelow90.bicep' = {
  name: 'AllowedVMSizesAssignment'
}

