
resource "azurerm_storage_account" "main" {
  name = "${var.prefix}${var.storage_acc}"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  account_tier = "Standard"
  account_replication_type = "LRS"

  allow_blob_public_access = true
  depends_on = [ 
    azurerm_resource_group.main
   ]
}

resource "azurerm_storage_container" "main" {
  name = "data"
  storage_account_name = azurerm_storage_account.main.name
  container_access_type = "blob"

  depends_on = [ 
    azurerm_storage_account.main
   ]
}

resource "azurerm_storage_blob" "sample" {
  name = "sample.txt"
  storage_account_name = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  type = "Block"
  source = "sample.txt"

  depends_on = [ 
    azurerm_storage_container.main
   ]
}

