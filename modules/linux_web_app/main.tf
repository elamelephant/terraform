# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = var.web_app_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  service_plan_id       = var.service_plan_id
  
  public_network_access_enabled = var.public_network_access_enabled
  https_only            = var.https_only
  
   dynamic "site_config" {
     for_each = [var.site_config]

     content {
        always_on                         = lookup(site_config.value, "always_on", null)
        app_command_line                  = lookup(site_config.value, "app_command_line", null)
        minimum_tls_version               = lookup(site_config.value, "minimum_tls_version", lookup(site_config.value, "min_tls_version", "1.2"))
        ftps_state                        = lookup(site_config.value, "ftps_state", "Disabled")
     
     dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          dotnet_version      = lookup(local.site_config.application_stack, "dotnet_version", null)
          java_server         = lookup(local.site_config.application_stack, "java_server", null)
          java_server_version = lookup(local.site_config.application_stack, "java_server_version", null)
          java_version        = lookup(local.site_config.application_stack, "java_version", null)
          node_version        = lookup(local.site_config.application_stack, "node_version", null)
          php_version         = lookup(local.site_config.application_stack, "php_version", null)
          python_version      = lookup(local.site_config.application_stack, "python_version", null)
          ruby_version        = lookup(local.site_config.application_stack, "ruby_version", null)
        }
      }
   }
 }
}