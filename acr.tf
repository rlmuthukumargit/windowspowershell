resource "azurerm_container_registry" "acr" {
  location            = var.resource_group_location
  name                = "containerRegistry1985"
  resource_group_name = var.resource_group_name
  sku                 = "Premium"
  admin_enabled       = false
 }