data "azurerm_resource_group" "main" {
  name = var.rg_name
}

resource "azurerm_storage_account" "storage_function" {
  name                            = var.storage_function_name
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  allow_nested_items_to_be_public = false
  min_tls_version                 = var.min_tls_version
  
}

// PRIVATE ENDPOINT
resource "azurerm_private_endpoint" "storage_function_pe" { 
  name                = format("pe-%s", var.storage_function_name)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("pl-%s", var.storage_function_name)
    private_connection_resource_id = azurerm_storage_account.storage_function.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

   private_dns_zone_group {
    name                 = var.storage_function_name
    private_dns_zone_ids = [var.blob_private_dns_id]
  }

}



resource "azurerm_storage_account" "storage_data" {
  name                            = var.storage_data_name
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  allow_nested_items_to_be_public = false
  min_tls_version                 = var.min_tls_version
  
}

// PRIVATE ENDPOINT
resource "azurerm_private_endpoint" "storage_data_pe" { 
  name                = format("pe-%s", var.storage_data_name)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("pl-%s", var.storage_data_name)
    private_connection_resource_id = azurerm_storage_account.storage_data.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

   private_dns_zone_group {
    name                 = var.storage_data_name
    private_dns_zone_ids = [var.blob_private_dns_id]
  }

}
