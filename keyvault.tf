resource "azurerm_key_vault" "mykeyvault" {
  location            = var.resource_group_location
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = "fbad172f-544f-4db3-acd4-e192e6030fb4"
  public_network_access_enabled = false
}

