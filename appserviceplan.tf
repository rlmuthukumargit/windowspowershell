resource "azurerm_service_plan" "svcplan" {
  name                = "example"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  os_type             = "Linux"
  sku_name            = "S1"
}