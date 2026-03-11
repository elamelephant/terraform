# Create a random name for the resource group using random_pet
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

# Create a resource group using the generated random name
resource "azurerm_resource_group" "rg_group" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

module "service_plan" {
  source  = "../modules/service_plan"

  plan_name       = var.plan_name
  location        = var.resource_group_location
  group_name = azurerm_resource_group.rg_group.name
  os_type  = "linux"
  sku_name = "B1"
}

module "linux_web_app" {
  source  = "../modules/linux_web_app"

  web_app_name = var.web_app_name 
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg_group.name
  stack               = var.stack
  service_plan_id = module.service_plan.id

  site_config = {
    http2_enabled = false
    app_command_line = "fastapi run main.py"

    application_stack = {
      python_version = "3.14"
    }
  }

}

module "sourcecontrol" {
    source    = "../modules/souce_control"
    app_id    = module.linux_web_app.id
    repo_url  = var.repo_url
    branch    = "master"
}