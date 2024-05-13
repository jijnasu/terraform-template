
data "azurerm_subnet" "main" {
  name = "subnetA"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  depends_on = [ 
    azurerm_virtual_network.main
   ]
}

resource "azurerm_public_ip" "main" {
  name = "vmPublicIP"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  allocation_method = "Static"
}

resource "azurerm_network_interface" "main" {
  name = "aznic"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location

  ip_configuration {
    name = "internal"
    # subnet_id = azurerm_virtual_network.main.subnetA.id
    subnet_id = data.azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  depends_on = [ 
    azurerm_virtual_network.main,
    azurerm_public_ip.main
   ]
}

resource "azurerm_windows_virtual_machine" "main" {
  name = "${var.prefix}-${var.vm}"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  size = "Standard_D2s_v3"
  admin_username = "demousr"
  admin_password = "Azure@123"
  availability_set_id = azurerm_availability_set.main.id

  network_interface_ids = [
    azurerm_network_interface.main.id
  ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2019-Datacenter"
    version = "latest"
  }

  depends_on = [ 
    azurerm_network_interface.main,
    azurerm_availability_set.main
   ]
}

# Adding more data disk
resource "azurerm_managed_disk" "main" {
  name                 = "data-disk"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 16
}

# Then we need to attach the data disk to the Azure virtual machine
resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  managed_disk_id    = azurerm_managed_disk.main.id
  virtual_machine_id = azurerm_windows_virtual_machine.main.id
  lun                = "0"
  caching            = "ReadWrite"

  depends_on = [
    azurerm_windows_virtual_machine.main,
    azurerm_managed_disk.main
  ]
}