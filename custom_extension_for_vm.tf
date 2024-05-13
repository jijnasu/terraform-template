
# Uploading the config file to Azure blob storage
resource "azurerm_storage_blob" "IIS_config" {
  name = "IIS_Config.ps1"
  storage_account_name = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  type = "Block"
  source = "IIS_Config.ps1"

  depends_on = [ 
    azurerm_storage_container.main
   ]
}

resource "azurerm_virtual_machine_extension" "main" {
  name                 = "vm-custom-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.main.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on = [
    azurerm_storage_blob.IIS_config
  ]
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.main.name}.blob.core.windows.net/data/IIS_Config.ps1"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config.ps1"     
    }
SETTINGS

}