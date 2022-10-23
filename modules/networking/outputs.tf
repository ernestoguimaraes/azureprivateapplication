
output "vnet_main_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_main_id" {
  value = azurerm_subnet.subnet001.id
}

output "subnet_app_plan_main_id" {
  value = azurerm_subnet.subnet002.id
}

