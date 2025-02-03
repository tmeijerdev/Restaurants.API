// Common parameters
@description('Prefix for resource names')
param genericPrefix string = 'Ciratum'

// Derive resource names
var randomSuffix             = uniqueString(resourceGroup().id)
var storageAccountName       = toLower('${genericPrefix}${take(randomSuffix, storageAccountSuffixLength)}')
var appInsightsName          = toLower('${genericPrefix}-applicationinsights')
var sqlServerName            = toLower('${genericPrefix}-sqlserver')
var sqlDatabaseName          = toLower('${genericPrefix}-sqldb')
var appServicePlanName       = toLower('${genericPrefix}-plan')
var appServiceName           = toLower('${genericPrefix}-app')

// Generic parameters
param creationDate string = utcNow('yyyy-MM-dd')
param createdBy string = 't.meijer.dev@hotmail.com'
param location string = resourceGroup().location


// Storage account parameters
param storageAccountSuffixLength int = 6 
param sku string = 'Standard_LRS'

// Database parameters
param sqlDbPlanSku string = 'Basic'
param sqlAdministratorPassword string = 'P@ssword123+'
param sqlAdministratorLogin string = 'sqlAdmin'

// App service parameters
param planSku string = 'B1'
param planTier string = 'Basic'

// ------------------------ //
// 1) Storage Account Module
// ------------------------ //

module storageAccountModule './StorageAccount/storageaccount.bicep' = {
  name: 'storageAccountDeploy'
  params: {
    sgName: storageAccountName
    location: location
    sku: sku
    createdBy: createdBy
    creationDate: creationDate
  }
}

// -------------------------------- //
// 2) Application Insights  Module
// -------------------------------- //

module appInsightsModule './AppInsights/appinsights.bicep' = {
  name: 'appInsightsDeploy'
  params: {
    name: appInsightsName
    rgLocation: location
    createdBy: createdBy
    creationDate: creationDate
  }
}

// -------------------------------- //
// 3) SQL Server + Database Module
// -------------------------------- //

module databaseModule './Database/database.bicep' = {
  name: 'sqlDbDeploy'
  params: {
    location: location
    databaseName: sqlDatabaseName
    sqlServerName: sqlServerName
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorPassword: sqlAdministratorPassword
    sqlDbPlanSku: sqlDbPlanSku
    createdBy: createdBy
    creationDate: creationDate
  }
}

// Build the final connection string
var databaseConnectionStringAdmin = format(
  'Server=tcp:{0},1433;Initial Catalog={1};Persist Security Info=False;User ID={2};Password={3};MultipleActiveResultSets=True;Encrypt=True;',
  databaseModule.outputs.serverUrl,
  databaseModule.outputs.databaseName,
  sqlAdministratorLogin,
  sqlAdministratorPassword
)


// ------------------------ //
// 4) App Service  Module
// ------------------------ //

module appServiceModule './AppService/appservice.bicep' = {
  name: 'appServiceDeploy'
  dependsOn: [
    appInsightsModule
  ]
  params: {
    planLocation: location
    appServiceName: appServiceName
    planName: appServicePlanName
    createdBy: createdBy
    planSku: planSku
    planTier: planTier
    creationDate: creationDate
    databaseConnectionString: databaseConnectionStringAdmin
    storageAccountConnectionString: storageAccountModule.outputs.storageAccountConnectionString
  }
}

