
param planLocation string = resourceGroup().location
param appServiceName string
param planName string
param creationDate string
param createdBy string
param planSku string
param planTier string
param databaseConnectionString string
param storageAccountConnectionString string

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: planName
  location: planLocation
  kind: 'linux'
  sku: {
    name: planSku
    tier: planTier
  }
  properties: {
    reserved: true
  }
}

resource appServiceResource 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceName
  location: planLocation
  kind: 'linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'DatabaseConnectionString'
          value: databaseConnectionString
        }
        {
          name: 'StorageAccountConnectionString'
          value: storageAccountConnectionString
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
