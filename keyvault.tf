resource "azurerm_key_vault" "mykeyvault" {
  location            = var.resource_group_location
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
  sku_name            = 
  tenant_id           = ""
}