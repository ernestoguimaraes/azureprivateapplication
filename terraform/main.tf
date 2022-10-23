terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.28.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.29.0"
    }

  # -----  Remote Terraform State
 }
   backend "azurerm" {
    resource_group_name  = "<ADD YOUR RESOURCE GROUP>"
    storage_account_name = "<ADD YOUR STORAGE NAME>"
    container_name       = "<ADD YOUR CONTAINER NAME"
    key                  = "<ADD YOUR STORAGE KEY>"
  }

}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }

  skip_provider_registration = true
}


locals {

  # ------- NAMING 
  
    
  # Resource group
  rg_name = "MyApp-RG"

  # Application Insights & Log Analytics  
  app_insights_name        = "appinsightssample-${var.sufix}"
  loganalytics_name         = "loganalyticssample-${var.sufix}"
  sku_loganalytics = "PerGB2018"
  retention_in_days = 90
  app_type = "other" 

  # Key Vault - This name should be unique
  kv_name = "keyvault${var.sufix}"
  
  # Networkig
  vnet_name = "vhd-${var.sufix}"
  vnet_address_space = ["10.2.0.0/26"] // 64 Ips
  security_group_name = "${local.vnet_name}-security-group"
  subnet_name = "subnet-${var.sufix}"
  subnet_plan_name = "subnet-appplan-${var.sufix}"
  subnet_address_prefix = ["10.2.0.0/28"]
  subnet_app_plan_address_prefix = ["10.2.0.16/28"]
  

  # App Plan and Function App
  app_plan_name = "AppPlan-${var.sufix}"
  web_app_name = "WebApp-${var.sufix}"    
  asp_sku_name = "S1"
  asp_zone_balancing_enabled = false
  asp_per_site_scaling_enabled = false
  application_alwaysOn = true
  application_ftpsState = "Disabled"
  application_http2_enabled = true
  application_python_version =  "3.9"
  asp_os_type = "Linux"
  application_min_tls_version = "1.2"

  # Storages
  storage_data_name = "storagedata${var.sufix}"
  storage_function_name = "storagefunction${var.sufix}"
  account_tier = "Standard"
  account_replication_type = "LRS"
  min_tls_version = "TLS1_2"

  # ------- EXPORTS
  keyvault_private_dns_id = module.private_dns.keyvault_private_dns_id
  webapp_private_dns_id = module.private_dns.webapp_private_dns_id
  blob_private_dns_id = module.private_dns.blob_private_dns_id
  
  app_insights_conn_string = module.app_insights.conn_string
  func_principalid = module.app_services.func_principalid

  
  storage_function_id = module.storages.storage_function_id
  storage_function_access_key = module.storages.storage_function_access_key
  storage_data_id = module.storages.storage_data_id
  storage_data_access_key = module.storages.storage_data_access_key

  private_endpoint_subnet_id = module.networking.subnet_main_id
  app_plan_subnet_id = module.networking.subnet_app_plan_main_id
 
   kv_id = module.keyvault.kv_id
  

}

resource "azurerm_resource_group" "main" {
  name = local.rg_name
  location = "Brazil South"
}

module "private_dns" {
  source = "../modules/dns"
  resource_group_name =  azurerm_resource_group.main.name
  depends_on = [
    azurerm_resource_group.main
  ]
}

module "aad" {
  source = "../modules/aad"
  func_principalid = local.func_principalid
  kv_id = local.kv_id
  storage_data_id =  local.storage_data_id

    depends_on = [
    azurerm_resource_group.main
  ]
}

module "networking" {
  source = "../modules/networking"    
  rg_name = azurerm_resource_group.main.name
  vnet_name = local.vnet_name
  vnet_address_space = local.vnet_address_space
  subnet_name = local.subnet_name
  subnet_address_prefix = local.subnet_address_prefix
  subnet_plan_name = local.subnet_plan_name
  subnet_app_plan_address_prefix = local.subnet_app_plan_address_prefix
  security_group_name = local.security_group_name
  
  depends_on = [
    azurerm_resource_group.main
  ]
}

module "app_insights" {
  source          = "../modules/app_insights"
  rg_name = azurerm_resource_group.main.name
  loganalytics_name        = local.loganalytics_name
  app_insights_name       = local.app_insights_name    
  sku_loganalytics = local.sku_loganalytics
  retention_in_days = local.retention_in_days

  depends_on = [
    azurerm_resource_group.main
  ]
}


module "app_services" {
  source          = "../modules/app_services"
  rg_name = azurerm_resource_group.main.name
  app_plan_name = lower(local.app_plan_name)
  web_app_name = local.web_app_name  
  asp_sku_name = local.asp_sku_name
  asp_os_type = local.asp_os_type
  asp_per_site_scaling_enabled = local.asp_per_site_scaling_enabled
  asp_zone_balancing_enabled = local.asp_zone_balancing_enabled
  storage_function_access_key = local.storage_function_access_key  
  application_alwaysOn = local.application_alwaysOn
  application_ftpsState = local.application_ftpsState
  application_min_tls_version = local.application_min_tls_version
  application_http2_enabled = local.application_http2_enabled
  app_insights_conn_string = local.app_insights_conn_string
  application_python_version = local.application_python_version
  storage_function_name = lower(local.storage_function_name)
  webapp_private_dns_id = local.webapp_private_dns_id
  private_endpoint_subnet_id = local.private_endpoint_subnet_id
  app_plan_subnet_id = local.app_plan_subnet_id

  depends_on = [
    azurerm_resource_group.main
  ]
}

module "storages" {
  source          = "../modules/storage"
  rg_name = azurerm_resource_group.main.name  
  storage_function_name = lower(local.storage_function_name)
  storage_data_name = lower(local.storage_data_name)
  account_tier = local.account_tier
  account_replication_type = local.account_replication_type
  min_tls_version = local.min_tls_version
  blob_private_dns_id = local.blob_private_dns_id
  private_endpoint_subnet_id = local.private_endpoint_subnet_id
  

  depends_on = [
    azurerm_resource_group.main
  ]
}


module "keyvault" {
  source  = "../modules/keyvault"
  kv_name = local.kv_name
  rg_name = azurerm_resource_group.main.name    
  private_kv_dns_id =   local.keyvault_private_dns_id  
  private_endpoint_subnet_id = local.private_endpoint_subnet_id

  depends_on = [
    azurerm_resource_group.main
  ]
}
