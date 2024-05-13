
resource "azurerm_availability_set" "main" {
  name = "${var.prefix}-${var.availability_set}"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  platform_fault_domain_count = 3
  platform_update_domain_count = 3
}