
resource "azurerm_role_assignment" "generalrole001" {
  role_definition_name = "Key Vault Secrets Officer"
  scope                = var.kv_id
  principal_id         = var.func_principalid
}

resource "azurerm_role_assignment" "generalrole002" {
  role_definition_name = "Storage Blob Data Contributor"
  scope                = var.storage_data_id
  principal_id         = var.func_principalid
}
