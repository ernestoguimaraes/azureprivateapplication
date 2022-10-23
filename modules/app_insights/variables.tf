
variable "loganalytics_name" {
  description = ""
  type        = string
  default     = ""
}

variable "app_insights_name" {
  description = ""
  type        = string
  default     = ""
}

variable "rg_name" {
  description = ""
  type        = string
  default     = ""
}

variable "app_type" {
  description = ""
  type        = string
  default     = "other"
}

variable "sku_loganalytics" {
  description = ""
  type        = string  
}

variable "retention_in_days" {
  description = ""
  type        = number  
}

