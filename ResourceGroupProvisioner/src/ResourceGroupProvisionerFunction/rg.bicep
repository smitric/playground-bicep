targetScope = 'subscription'

param resourceGroupName string
param resourceGroupLocation string
param pillar string
param usage string
param role string

resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
  tags: {
    Pillar: pillar
    Usage: usage
    Role: role
    Tier: 'Personal'
  }
}
