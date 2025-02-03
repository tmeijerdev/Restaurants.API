param sqlServerName string
param databaseName string
param location string 
param sqlAdministratorLogin string
param sqlDbPlanSku string
@secure()
param sqlAdministratorPassword string
param creationDate string
param createdBy string


// Resource: SQL Server
resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorPassword
  }
  tags: {
    CreatedAt: creationDate
    CreatedBy: createdBy
  }
}

// Resource: SQL Database
resource sqlDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  sku: {
    name: sqlDbPlanSku
  }
  tags: {
    CreatedAt: creationDate
    CreatedBy: createdBy
  }
}


output databaseName string = trim(sqlDatabase.name)
output serverUrl string = trim(sqlServer.properties.fullyQualifiedDomainName)
