output "func_principalid" {
  value = azurerm_linux_function_app.func_001.identity[0].principal_id
}
