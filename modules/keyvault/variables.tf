
variable "kv_name" {
  description = ""
  type        = string
  default     = ""
}

variable "kv_sku" {
  description = ""
  type        = string
  default     = "standard"
}

variable "rg_name" {
  type = string
}


variable "private_kv_dns_id" {
  type = string
}

variable "private_endpoint_subnet_id" {
  type = string
}
