variable "resource_group_location" {
  type        = string
  default     = "canadacentral"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "web_app_name" {
  description = "app name"
  type        = string
  default =   "fastapi-demo-wesdq"
}

variable "plan_name" {
  description = "name of the servie plan"
  type        = string
  default = "webapp_linux_B1"
}

variable "github_secret_name" {
  description = "github's secret pat key"
  type = string
  default = "github-access"
  }
  
variable "keyvault_name" {
  description = "Azure keyvault name"
  type = string
  default = "AIapp-vault"
}

variable "vault_resourcegroup_name" {
  description = "Azure keyvault resource group name"
  type = string
  default = "elam-_group"
}