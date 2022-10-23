
data "azurerm_resource_group" "main" {
  name = var.rg_name
}


resource "azurerm_service_plan" "asp_001" {
  name                     = var.app_plan_name
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  os_type                  = var.asp_os_type
  sku_name                 = var.asp_sku_name
  per_site_scaling_enabled = var.asp_per_site_scaling_enabled
  zone_balancing_enabled   = var.asp_zone_balancing_enabled


}

resource "azurerm_linux_function_app" "func_001" {
  name                       = var.web_app_name
  resource_group_name        = data.azurerm_resource_group.main.name
  location                   = data.azurerm_resource_group.main.location
  storage_account_name       = var.storage_function_name
  storage_account_access_key = var.storage_function_access_key
  service_plan_id            = azurerm_service_plan.asp_001.id

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                              = var.application_alwaysOn
    ftps_state                             = var.application_ftpsState
    minimum_tls_version                    = var.application_min_tls_version
    http2_enabled                          = var.application_http2_enabled
    application_insights_connection_string = var.app_insights_conn_string
    vnet_route_all_enabled                 = true

    application_stack {
      python_version = var.application_python_version
    }

  }

}

// PRIVATE ENDPOINT
resource "azurerm_private_endpoint" "func_001_pe" { 
  name                = format("pe-%s", var.web_app_name)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("pl-%s", var.web_app_name)
    private_connection_resource_id = azurerm_linux_function_app.func_001.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

   private_dns_zone_group {
    name                 = var.web_app_name
    private_dns_zone_ids = [var.webapp_private_dns_id]
  }

}


# # ----------- NETWORK Integration
 resource "azurerm_app_service_virtual_network_swift_connection" "aspnet001" {
   app_service_id = azurerm_linux_function_app.func_001.id
   subnet_id      = var.app_plan_subnet_id 
 }