data "azurerm_resource_group" "main" {
  name = var.rg_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.security_group_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = var.vnet_address_space

}

//Hosts the Private Endpoints
resource "azurerm_subnet" "subnet001" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
  private_endpoint_network_policies_enabled = false
}

//Hosts the App Plan Network Integration
resource "azurerm_subnet" "subnet002" {
  name                 = var.subnet_plan_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_app_plan_address_prefix
    
    delegation {
      name = "App Plan Farms"
      service_delegation {
        name = "Microsoft.Web/serverFarms"
      }
    }
}
  
