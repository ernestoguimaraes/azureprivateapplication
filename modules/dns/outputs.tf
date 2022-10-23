output "keyvault_private_dns_id" {
  value = azurerm_private_dns_zone.keyvaultPrivateDns.id
}

output "webapp_private_dns_id" {
   value = azurerm_private_dns_zone.webAppPrivateDns.id
}

output "blob_private_dns_id" {
   value = azurerm_private_dns_zone.blobPrivateDns.id
}