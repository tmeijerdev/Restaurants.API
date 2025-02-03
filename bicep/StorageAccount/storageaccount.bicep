param sgName string
param location string = resourceGroup().location
param sku string = 'Standard_LRS' 
param kind string = 'StorageV2'
param creationDate string 
param createdBy string

// Resource: Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: sgName
  location: location
  kind: kind
  sku: {
    name: sku
  }
  properties: {
    accessTier: 'Hot'  
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
  tags: {
    CreatedAt: creationDate
    CreatedBy: createdBy
  }
}

output storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${sgName};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
