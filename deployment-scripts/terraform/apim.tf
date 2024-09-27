# Create the API Management instance
resource "azurerm_api_management" "apim" {
  depends_on = [azurerm_linux_function_app.upload_function]
  name                = "${local.name_prefix}-${var.apim_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_email     = var.publisher_email
  publisher_name      = var.publisher_name
  sku_name            = "Developer_1"

}

# API
# Step 1: Create the API without any policy
resource "azurerm_api_management_api" "translation_api" {
  name                  = "${local.name_prefix}-${var.api_name}"
  resource_group_name   = azurerm_resource_group.rg.name
  api_management_name   = azurerm_api_management.apim.name
  revision              = "1"
  display_name          = "Translation Service API"
  path                  = var.api_path
  subscription_required = false
  service_url           = "https://${azurerm_linux_function_app.upload_function.default_hostname}/api"
  protocols = ["https"]

#   provisioner "local-exec" {
#     command = <<EOT
#       ./update_api_constants.sh "$(terraform output api_management_url)"
#     EOT
#   }

}

resource "azurerm_api_management_api_policy" "translation_api_policy_extended" {
  api_name            = azurerm_api_management_api.translation_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <cors>
      <allowed-origins>
        <origin>*</origin>
      </allowed-origins>
      <allowed-methods>
        <method>GET</method>
        <method>POST</method>
      </allowed-methods>
    </cors>
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML

  depends_on = [azurerm_api_management_api.translation_api]
}

# Define individual operations
resource "azurerm_api_management_api_operation" "get_all_logs" {
  operation_id        = "get-all-logs"
  api_name            = azurerm_api_management_api.translation_api.name
  api_management_name = azurerm_api_management_api.translation_api.api_management_name
  resource_group_name = azurerm_api_management_api.translation_api.resource_group_name
  display_name        = "Get All Logs"
  method              = "GET"
  url_template        = "/get_all_logs"
  description         = "Retrieves all logs"

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_operation" "get_all_prompts" {
  operation_id        = "get-all-prompts"
  api_name            = azurerm_api_management_api.translation_api.name
  api_management_name = azurerm_api_management_api.translation_api.api_management_name
  resource_group_name = azurerm_api_management_api.translation_api.resource_group_name
  display_name        = "Get All Prompts"
  method              = "GET"
  url_template        = "/get_all_prompts"
  description         = "Retrieves all prompts"

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_operation" "get_logs_by_date" {
  operation_id        = "get-logs-by-date"
  api_name            = azurerm_api_management_api.translation_api.name
  api_management_name = azurerm_api_management_api.translation_api.api_management_name
  resource_group_name = azurerm_api_management_api.translation_api.resource_group_name
  display_name        = "Get Logs By Date"
  method              = "GET"
  url_template        = "/get_logs_by_date"
  description         = "Retrieves logs by date"

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_operation" "upload_file" {
  operation_id        = "upload-file"
  api_name            = azurerm_api_management_api.translation_api.name
  api_management_name = azurerm_api_management_api.translation_api.api_management_name
  resource_group_name = azurerm_api_management_api.translation_api.resource_group_name
  display_name        = "Upload File"
  method              = "POST"
  url_template        = "/upload_file"
  description         = "Uploads a file"

  response {
    status_code = 200
  }
}

# Output the API Management URL
output "api_management_url" {
  value = "https://${azurerm_api_management.apim.name}.azure-api.net/${azurerm_api_management_api.translation_api.path}"
}

