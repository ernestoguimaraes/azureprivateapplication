
data "azurerm_resource_group" "main" {
  name = var.rg_name
}


resource "azurerm_log_analytics_workspace" "log_analytic" {
  name                = var.loganalytics_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = var.sku_loganalytics
  retention_in_days   = var.retention_in_days
  
}

resource "azurerm_application_insights" "app_insights" {
  name                = var.app_insights_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.log_analytic.id
  application_type    = var.app_type

}