resource "azurerm_cognitive_account" "formrec" {
  kind                = "Face"
  location            = var.resource_group_location
  name                = "example-account"
  resource_group_name = var.resource_group_name
  sku_name            = "S0"
}