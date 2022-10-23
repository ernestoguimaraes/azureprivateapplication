resource "azurerm_private_dns_zone" "keyvaultPrivateDns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name  
}

resource "azurerm_private_dns_zone" "webAppPrivateDns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name  
} 

resource "azurerm_private_dns_zone" "blobPrivateDns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name  
} 
