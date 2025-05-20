resource "azurerm_virtual_network" "myvirtualnw" {
  address_space       = ["10.30.24.0/21"]
  location            = var.resource_group_location
  name                = "myvnet-01"
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "mysubnet" {
  address_prefixes     = ["10.30.25.0/24"]
  name                 = "vn-subnet-01"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.myvirtualnw.name
}
