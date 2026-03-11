#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = var.webapp_id
  repo_url           = var.repo_url
  branch             = var.branch_name
  use_manual_integration = false
  use_mercurial      = false
}