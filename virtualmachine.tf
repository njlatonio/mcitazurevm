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

}


resource "azurerm_resource_group" "example" {
  name     = var.name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  address_space       = var.address_space
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_network_interface" "main" {
  name                = variable.nic_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = var.ip_config_name
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}


#Question 11
resource "azurerm_virtual_machine" "main" {
  for_each              = {for machine in local.vm_names: machine=>machine}
  name                  = each.value.name
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.storage_image_reference_version
  }
  storage_os_disk {
    name              = var.storage_os_disk_name
    caching           = var.caching
    create_option     = var.create_option
    managed_disk_type = var.managed_disk_type
  }
  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = var.disable_password_authentication
  }
  tags = {
    environment = var.environment
  }
}


#Question 12 - via yaml
resource "azurerm_virtual_machine" "main_yaml" {
  for_each              = {for value in local.azurevmlist: "${value.name}"=>value}
  name                  = each.value.name
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.storage_image_reference_version
  }
  storage_os_disk {
    name              = var.storage_os_disk_name
    caching           = var.caching
    create_option     = var.create_option
    managed_disk_type = var.managed_disk_type
  }
  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = var.disable_password_authentication
  }
  tags = {
    environment = var.environment
  }
}

