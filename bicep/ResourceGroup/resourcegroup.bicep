targetScope = 'subscription'

param rgName string = 'SampleProject-ResourceGroup'
param rgLocation string = 'West Europe'
param creationDate string = utcNow('yyyy-MM-dd')
param createdBy string = 't.meijer.dev@hotmail.com'



resource rgName_resource 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: rgName
  location: rgLocation
  tags: {
    CreatedAt: creationDate
    CreatedBy: createdBy
  }
}
