
data "azurerm_resource_group" "main" {
  name = var.rg_name
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "kv" {
  name                       = var.kv_name
  location                   = data.azurerm_resource_group.main.location
  resource_group_name        = var.rg_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  sku_name                   = var.kv_sku
  enable_rbac_authorization  = true

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"   
  }

   lifecycle {
    prevent_destroy = true
  }
  
}

// PRIVATE ENDPOINT

resource "azurerm_private_endpoint" "kv_pe" { 
  name                = format("pe-%s", var.kv_name)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("pl-%s", var.kv_name)
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

   private_dns_zone_group {
    name                 = var.kv_name
    private_dns_zone_ids = [var.private_kv_dns_id]
  }

}

