# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-${random_integer.ri.result}"
  location            = var.location
  resource_group_name = var.group_name
  os_type             = var.os_type
  sku_name            = var.sku_name
}