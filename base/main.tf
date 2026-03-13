# Configure the keyvault to download the secrets
# This is not the correct way, usually, it has to be passed via CI/CD env varaible TF_VAR
data "azurerm_key_vault" "keyvault" {
  name                = "${var.keyvault_name}"
  resource_group_name = "${var.vault_resourcegroup_name}"
}

# download the secret from the key vault
# This is not the correct way, usually, it has to be passed via CI/CD env varaible TF_VAR
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

# Call the module to create a azure app service plan
module "service_plan" {
  source = "git::https://github.com/elamelephant/terraform_modules.git//service_plan?ref=v1.3"

  plan_name       = var.plan_name
  location        = var.resource_group_location
  group_name      =  azurerm_resource_group.rg_group.name
  os_type  = "Linux"
  sku_name = "B1"
}

# Call the module to create a azure web linux app
module "linux_web_app" {
  source = "git::https://github.com/elamelephant/terraform_modules.git//linux_web_app?ref=v1.3"

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
      SCM_DO_BUILD_DURING_DEPLOYMENT = true # It enables automatic dependency installation
    }
  depends_on = [ module.service_plan ]

}

# Assign the github token to the source control for the access
# This is not the correct way, usually, it has to be passed via CI/CD env varaible TF_VAR
# detail: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/source_control_token
resource "azurerm_source_control_token" "access" {
  type  = "GitHub"
  token = "${data.azurerm_key_vault_secret.github_pat.value}"
}

# Call the module to configure the source control for CI/CD
module "sourcecontrol" {
    source = "git::https://github.com/elamelephant/terraform_modules.git//source_control?ref=v1.3"
    webapp_id = module.linux_web_app.id
    repo_url  = "https://github.com/elamelephant/azure-webapp-fastapi"
    branch_name =   "main"
    depends_on = [ module.linux_web_app, azurerm_source_control_token.access ]
    runtime_stack = "python"
    runtime_version = "3.14"

}