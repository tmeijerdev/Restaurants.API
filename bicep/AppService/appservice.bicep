
param planLocation string = resourceGroup().location
param appServiceName string
param planName string
param creationDate string
param createdBy string
param planSku string
param planTier string
param databaseConnectionString string
param storageAccountConnectionString string
param appInsightsConnectionString string

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: planName
  location: planLocation
  sku: {
    name: planSku
    tier: planTier
  }
}

resource appServiceResource 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceName
  location: planLocation
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      connectionStrings: [
        {
          name: 'RestaurantsDb'
          connectionString: databaseConnectionString
          type: 'SQLAzure' 
        }
        {
          name: 'StorageAccountConnectionString'
          connectionString: storageAccountConnectionString
          type: 'Custom'
        }
      ]
      appSettings: [
        {
          name: 'StorageAccountConnectionString'
          value: storageAccountConnectionString
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    CreatedAt: creationDate
    CreatedBy: createdBy
  }
}
