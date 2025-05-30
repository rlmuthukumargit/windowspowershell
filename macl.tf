resource "azurerm_application_insights" "appins" {
  name                = "workspace-example-ai"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

resource "azurerm_machine_learning_workspace" "macl" {
  application_insights_id = azurerm_application_insights.appins.id
  key_vault_id            = azurerm_key_vault.mykeyvault.id
  location                = var.resource_group_location
  name                    = "maclsvc123"
  resource_group_name     = var.resource_group_name
  storage_account_id      = azurerm_storage_account.muthustg.id

  identity {
    type = "SystemAssigned"
  }

}