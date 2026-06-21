targetScope = 'resourceGroup'

@description('Static Web App resource name')
param staticWebAppName string

@description('Azure region for resources')
param location string

@description('Name of the azd environment')
param environmentName string

resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  tags: {
    'azd-service-name': 'web'
    'azd-env-name': environmentName
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
  }
}

output STATIC_WEB_APP_NAME string = staticWebApp.name
output STATIC_WEB_APP_DEFAULT_HOSTNAME string = staticWebApp.properties.defaultHostname
