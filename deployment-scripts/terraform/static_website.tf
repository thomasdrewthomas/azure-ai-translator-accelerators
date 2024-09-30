variable "github_token" {}
variable "github_owner" {}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# # Azure region
# variable "azure_static_web_region" {
#   type        = string
#   description = "(Required) Region to use for your SWA deployment. Currently supported regions are westus2, centralus, eastus2, westeurope, eastasia, eastasiastage"
#
#   validation {
#     condition     = contains(["westus2", "centralus", "eastus2", "westeurope", "eastasia", "eastasiastage"], var.region)
#     error_message = "You must specify a supported region. Currently supported regions are westus2, centralus, eastus2, westeurope, eastasia, eastasiastage."
#   }
# }

locals {
  azure_static_web_region = "westeurope"
  github_repository       = "azure-ai-translator-accelerators"
  api_token_var           = "AZURE_STATIC_WEB_APPS_API_TOKEN"
}

resource "azurerm_static_web_app" "webapp" {
  depends_on = [azurerm_linux_function_app.upload_function]
  location            = local.azure_static_web_region
  name                = "${local.name_prefix}-webapp"
  resource_group_name = azurerm_resource_group.rg.name
  sku_size            = "Standard"
  sku_tier            = "Standard"
  tags                = local.default_tags
  #   identity - (Optional) An identity block as defined below.
  #   app_settings - (Optional) A key-value pair of App Settings.
  #   basic_auth - (Optional) A basic_auth block as defined below.
  #   A basic_auth block supports the following:
  #   password - (Required) The password for the basic authentication access.
  #   environments - (Required) The Environment types to use the Basic Auth for access. Possible values include AllEnvironments and StagingEnvironments.
}
#
resource "github_actions_secret" "webapp_api_key" {
  depends_on = [azurerm_static_web_app.webapp]
  repository      = local.github_repository
  secret_name     = local.api_token_var
  plaintext_value = azurerm_static_web_app.webapp.api_key
}

#
# # This will cause github provider crash, until https://github.com/integrations/terraform-provider-github/pull/732 is merged.
resource "github_repository_file" "foo" {
  depends_on = [github_actions_secret.webapp_api_key]
  repository = local.github_repository
  branch     = "main"
  file       = ".github/workflows/azure-ai-static-web-app.yml"
  content = templatefile("./azure-static-web-app.yml",
    {
      app_location    = "/document-translate-web"
      output_location = "build"
      api_runtime     = "node:18"
      api_token_var   = local.api_token_var
    }
  )
  commit_message      = "Release Azure AI Translator by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

}

output "hostname" {
  value = "https://${azurerm_static_web_app.webapp.default_host_name}"
}