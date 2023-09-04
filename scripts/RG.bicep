targetScope = 'subscription'

param resourceGroupName string
param resourceGroupLocation string
param pillar string
param usage string
param resourceTags object = {
  Pillar: pillar
  Usage: usage
}

resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
  tags: resourceTags
}
