resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.resource_group}"
  location = var.location
}