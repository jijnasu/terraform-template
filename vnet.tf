resource "azurerm_virtual_network" "main" {
  name = "${var.prefix}-${var.vnet}"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  address_space = [ "10.0.0.0/16" ]

  subnet {
    name = "subnetA"
    address_prefix = "10.0.1.0/24"
  }

#   subnet {
#     name = "subnetB"
#     address_prefix = "10.0.2.0/24"
#   }

}