param name string
param rgLocation string = resourceGroup().location
param creationDate string
param createdBy string


resource appIns 'Microsoft.Insights/components@2020-02-02' = {
  name:name
  kind:'web'
  location:rgLocation
  properties:{
    Application_Type:'web'
    Request_Source:'rest'
    Flow_Type:'Bluefield'
  }
  tags: {
    CreatedAt: creationDate
    CreatedBy: createdBy
  }
}

// output appInsightsKey string = reference(appIns.id, '2014-04-01').InstrumentationKey
output appInsightsConnectionString string = appIns.properties.ConnectionString

