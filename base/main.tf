data "azurerm_key_vault" "keyvault" {
  name                = "${var.keyvault_name}"
  resource_group_name = "${var.vault_resourcegroup_name}"
}

data "azurerm_key_vault_secret" "github_pat" {
  name         = "${var.github_secret_name}"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

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
  source = "git::https://github.com/elamelephant/terraform_modules.git//service_plan?ref=v1.1"

  plan_name       = var.plan_name
  location        = var.resource_group_location
  group_name      =  azurerm_resource_group.rg_group.name
  os_type  = "Linux"
  sku_name = "B1"
}

module "linux_web_app" {
  source = "git::https://github.com/elamelephant/terraform_modules.git//linux_web_app?ref=v1.1"

  web_app_name = var.web_app_name 
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg_group.name
  service_plan_id = module.service_plan.id

  site_config = {
    http2_enabled = false
    app_command_line = "fastapi run main.py"

    application_stack = {
      python_version = "3.14"
    }
    
  }
  app_settings = {
      SCM_DO_BUILD_DURING_DEPLOYMENT = true
    }
  depends_on = [ module.service_plan ]

}

resource "azurerm_source_control_token" "access" {
  type  = "GitHub"
  token = "${data.azurerm_key_vault_secret.github_pat.value}"
}

module "sourcecontrol" {
    source = "git::https://github.com/elamelephant/terraform_modules.git//source_control?ref=v1.1"
    webapp_id = module.linux_web_app.id
    repo_url  = "https://github.com/elamelephant/azure-webapp-fastapi"
    branch_name =   "main"
    depends_on = [ module.linux_web_app, azurerm_source_control_token.access ]
}