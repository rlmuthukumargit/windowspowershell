resource "azurerm_storage_account" "muthustg" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.resource_group_location
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  public_network_access_enabled = true
  }

resource "azurerm_storage_share" "file_share" {
  name                     = "filesharedev"
  storage_account_id       = azurerm_storage_account.muthustg.id
  quota                    = 50
  }