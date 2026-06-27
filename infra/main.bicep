targetScope = 'subscription'

@description('Name of the azd environment (for example: dev, test, prod).')
param environmentName string = 'dev'

@description('Azure region for all resources.')
param location string = deployment().location

var resourceToken = uniqueString(subscription().id, environmentName, location)
var resourceGroupName = 'rg-${environmentName}'
var staticWebAppName = 'swa-oodapnotes-fwvanl'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: {
    'azd-env-name': environmentName
  }
}

module web './resources.bicep' = {
  name: 'web-${resourceToken}'
  scope: resourceGroup
  params: {
    staticWebAppName: staticWebAppName
    location: location
    environmentName: environmentName
  }
}

output AZURE_RESOURCE_GROUP string = resourceGroup.name
output STATIC_WEB_APP_NAME string = web.outputs.STATIC_WEB_APP_NAME
output STATIC_WEB_APP_DEFAULT_HOSTNAME string = web.outputs.STATIC_WEB_APP_DEFAULT_HOSTNAME
