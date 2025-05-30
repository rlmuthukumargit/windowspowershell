resource "azurerm_linux_function_app" "functionapp1" {
  name                       = "fnappdev12"
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.svcplan.id
  storage_account_name       = azurerm_storage_account.muthustg.name
#  functions_extension_version = "~4"
#  os_type                    = "linux"
  storage_account_access_key = azurerm_storage_account.muthustg.primary_access_key
#  app_settings = {
#    WEBSITE_CONTENTSHARE = azurerm_storage_share.file_share.name
#    WEBSITE_CONTENTAZUREFILESHARE = azurerm_storage_account.muthustg.primary_access_key
#    WEBSITE_ENABLE_SHARE_MODE = "true"
#  }

  site_config {
    application_insights_key = azurerm_application_insights.appins.id
    application_stack {
      python_version = "3.11" # Change this based on your language stack
    }
  }
}

resource "azurerm_linux_function_app" "functionapp2" {
  name                       = "fnappdev13"
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.svcplan.id
  storage_account_name       = azurerm_storage_account.muthustg.name
#  functions_extension_version = "~4"
#  os_type                    = "linux"
  storage_account_access_key = azurerm_storage_account.muthustg.primary_access_key
#  app_settings = {
#    WEBSITE_CONTENTSHARE = azurerm_storage_share.file_share.name
#    WEBSITE_CONTENTAZUREFILESHARE = azurerm_storage_account.muthustg.primary_access_key
#    WEBSITE_ENABLE_SHARE_MODE = "true"
#  }
  site_config {
    application_insights_key = azurerm_application_insights.appins.id
    application_stack {
      python_version = "3.11" # Change this based on your language stack
    }
  }
}

