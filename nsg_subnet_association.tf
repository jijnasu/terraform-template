resource "azurerm_network_security_group" "main" {
  name                = "app-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

# We are creating a rule to allow traffic on port 80
  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = data.azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id

  depends_on = [
    azurerm_network_security_group.main,
    data.azurerm_subnet.main
  ]
}