locals{
  #Question 13
  azurevmconfig_Q13=[for f in fileset("${path.module}/vmfolder_Q13", "[^_]*.yaml") : yamldecode(file("${path.module}/vmfolder_Q13/${f}"))]
  azurevmlist_Q13 = flatten([
    for app in local.azurevmconfig_Q13 : [
      for azurevm in try(app.rgconfig, []) :{
        name=azurevm.name
        location=azurevm.location
      }
    ]
])

}

resource "azurerm_resource_group" "example_Q13" {
  for_each = {for value in local.azurevmlist_Q13: "${value.name}"=>value}
  name     = each.value.name
  location = each.value.location
}
