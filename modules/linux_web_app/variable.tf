variable "location" {
  description = "Azure location."
  type        = string
}

variable "service_plan_id" {
  description = "ID of the Service Plan that hosts the App Service."
  type        = string
}

variable "web_app_name" {
  description = "ID of the Service Plan that hosts the App Service."
  type        = string
}

variable "site_config" {
  description = "Site config for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config). IP restriction attribute is no more managed in this block."
  type        = any
  default     = {}
}

variable "https_only" {
  description = "HTTPS restriction for App Service. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only)."
  type        = bool
  default     = true
}

variable "stack" {
  description = "Project stack name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "public_network_access_enabled" {
  description = "To enable public network access"
  type        = bool
  default     = true
}