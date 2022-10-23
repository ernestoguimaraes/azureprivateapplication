
output "storage_function_id" {
  value = azurerm_storage_account.storage_function.id
}

output "storage_function_access_key" {
  value = azurerm_storage_account.storage_function.primary_access_key
}

output "storage_data_id" {
  value = azurerm_storage_account.storage_data.id
}

output "storage_data_access_key" {
  value = azurerm_storage_account.storage_data.primary_access_key
}


