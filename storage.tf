resource "azurerm_storage_account" "muthustg" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.resource_group_location
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
}