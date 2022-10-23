variable "subnet_name" {
  description = ""
  type        = string
}

variable "vnet_name" {
  description = ""
  type        = string
}

variable "rg_name" {
  description = ""
  type        = string
}


variable "security_group_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_address_prefix" {
  type = list(string)
}

variable "subnet_app_plan_address_prefix" {
  type = list(string)
}

variable "subnet_plan_name" {
  type = string
}





