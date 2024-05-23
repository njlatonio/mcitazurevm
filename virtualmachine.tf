locals{
  #Question 11
  vm_names=["firstvm","secondvm","thirdvm","fourthvm","fifthvm"]

  #Question 12 - via yaml
  azurevmconfig=[for f in fileset("${path.module}/vmfolder", "[^_]*.yaml") : yamldecode(file("${path.module}/vmfolder/${f}"))]
  azurevmlist = flatten([
    for app in local.azurevmconfig : [
      for azurevm in try(app.azurevmconfiguration, []) :{
        name=azurevm.name
      }
    ]
])

  #Question 13
  azurevmconfig_Q13=[for f in fileset("${path.module}/vmfolder_Q13", "[^_]*.yaml") : yamldecode(file("${path.module}/vmfolder_Q13/${f}"))]
  azurevmlist_Q13 = flatten([
   for app in local.azurevmconfig_Q13 : [
     for azurevm in try(app.resourcegroupconfiguration, []) :{
      name=azurevm.name
      location=azurevm.location
      }
    ]
])
}


resource "azurerm_resource_group" "example" {
  for_each = {for value in local.azurevmlist_Q13: "${value.name}"=>value}
  name     = each.value.name
  location = each.value.location
}

resource "azurerm_virtual_network" "main" {
  for_each = {for value in local.azurevmlist_Q13: "${value.name}"=>value}
  name                = "network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example[each.value.location]
  resource_group_name = azurerm_resource_group.example[each.value.name]
}

resource "azurerm_subnet" "internal" {
  for_each = {for value in local.azurevmlist_Q13: "${value.name}"=>value}
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example[each.value.name]
  virtual_network_name = azurerm_virtual_network.main[each.value.name]
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  for_each = {for value in local.azurevmlist_Q13: "${value.name}"=>value}
  name                = "nic"
  location            = azurerm_resource_group.example[each.value.location]
  resource_group_name = azurerm_resource_group.example[each.value.name]

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal[each.value.id]
    private_ip_address_allocation = "Dynamic"
  }
}

/*
resource "azurerm_resource_group" "example" {
  name     = "resources"
  location = "West Europe"
}
#Question 11
resource "azurerm_virtual_machine" "main" {
  for_each              = {for machine in local.vm_names: machine=>machine}
  name                  = "vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}


#Question 12 - via yaml
resource "azurerm_virtual_machine" "main_yaml" {
  for_each              = {for value in local.azurevmlist: "${value.name}"=>value}
  name                  = each.value.name
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
*/
