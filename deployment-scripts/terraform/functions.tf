data "archive_file" "document_upload_function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../document-upload-function"
  output_path = "${path.module}/document-upload-function.zip"
}

data "archive_file" "document_translate_function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../document-translate-function"
  output_path = "${path.module}/document-translate-function.zip"
}

resource "azurerm_application_insights" "functions_app_insights" {
  name                = "${local.name_prefix}-${var.function_app_insights_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  tags                = local.default_tags
}


resource "azurerm_service_plan" "functions" {
  name                = "${local.name_prefix}-${var.function_service_plan_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = local.default_tags
}

resource "azurerm_linux_function_app" "upload_function" {
  depends_on                 = [azurerm_postgresql_flexible_server_database.citus_db]
  name                       = "${local.name_prefix}-${var.function_app_name_upload}-${random_string.unique.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.functions.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  #   webdeploy_publish_basic_authentication_enabled = true
  #   ftp_publish_basic_authentication_enabled       = true

  site_config {
    always_on                              = true
    remote_debugging_enabled               = true
    application_insights_connection_string = azurerm_application_insights.functions_app_insights.connection_string
    application_stack {
      python_version = "3.11"
    }
    ftps_state = "AllAllowed"
  }

  app_settings = {
    storage_name                   = azurerm_storage_account.storage.name
    FUNCTIONS_WORKER_RUNTIME       = "python"
    ENABLE_ORYX_BUILD              = true
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    WEBSITE_RUN_FROM_PACKAGE       = "1"
    AZURE_CONNECTION_STRING        = azurerm_storage_account.storage.primary_connection_string
    AZURE_STORAGE_ACCOUNT          = azurerm_storage_account.storage.name
    SAS_TOKEN                      = data.azurerm_storage_account_sas.storage_sas_token.sas
    CONTAINER_NAME                 = var.storage_container_name
    DB_HOST                        = azurerm_postgresql_flexible_server.translator_db.fqdn
    DB_PORT                        = 5432
    DB_NAME                        = azurerm_postgresql_flexible_server_database.citus_db.name
    DB_USER                        = azurerm_postgresql_flexible_server.translator_db.administrator_login
    DB_PASSWORD                    = random_password.db_password.result
    DB_SSLMODE                     = "require"

  }
  #   zip_deploy_file = "./document-upload-function.zip"
  tags = local.default_tags

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  provisioner "local-exec" {
    command = "az functionapp deployment source config-zip --resource-group ${azurerm_resource_group.rg.name} --name ${local.name_prefix}-${var.function_app_name_upload}-${random_string.unique.result} --src ${data.archive_file.document_upload_function_zip.output_path} --build-remote true "
  }
}

# # New data source to retrieve the function app host keys
# data "azurerm_function_app_host_keys" "upload_function_keys" {
#   name                = azurerm_linux_function_app.upload_function.name
#   resource_group_name = azurerm_resource_group.rg.name
#
#   depends_on = [azurerm_linux_function_app.upload_function]
# }
#
# # Output the default function key
# output "upload_function_default_key" {
#   value     = data.azurerm_function_app_host_keys.upload_function_keys.default_function_key
#   sensitive = true
# }


resource "azurerm_linux_function_app" "translate_function" {
  depends_on = [
    azurerm_postgresql_flexible_server_database.citus_db,
    azurerm_cognitive_account.translator,
    azurerm_cognitive_account.openai
  ]
  name                       = "${local.name_prefix}-${var.function_app_name_translate}-${random_string.unique.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.functions.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  #   webdeploy_publish_basic_authentication_enabled = true
  #   ftp_publish_basic_authentication_enabled       = true

  site_config {
    always_on                              = true
    remote_debugging_enabled               = true
    application_insights_connection_string = azurerm_application_insights.functions_app_insights.connection_string
    application_stack {
      python_version = "3.11"
    }
    ftps_state = "AllAllowed"
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME         = "python"
    ENABLE_ORYX_BUILD                = true
    SCM_DO_BUILD_DURING_DEPLOYMENT   = true
    WEBSITE_RUN_FROM_PACKAGE         = "1"
    storage_name                     = azurerm_storage_account.storage.name
    AZURE_CONNECTION_STRING          = azurerm_storage_account.storage.primary_connection_string
    AZURE_STORAGE_ACCOUNT            = azurerm_storage_account.storage.name
    SAS_TOKEN                        = data.azurerm_storage_account_sas.storage_sas_token.sas
    CONTAINER_NAME                   = var.storage_container_name
    BlobStorageConnectionString      = azurerm_storage_account.storage.primary_connection_string
    AzureWebJobsFeatureFlags         = "EnableWorkerIndexing"
    TRANSLATE_DOCUMENT_ENDPOINT      = "https://${azurerm_cognitive_account.translator.custom_subdomain_name}.cognitiveservices.azure.com"
    TRANSLATE_SUBSCRIPTION_KEY       = azurerm_cognitive_account.translator.primary_access_key
    AZURE_OPENAI_ENDPOINT            = azurerm_cognitive_account.openai.endpoint
    CHAT_COMPLETIONS_DEPLOYMENT_NAME = var.openai_deployments[0].name
    OPEN_AI_API_KEY                  = azurerm_cognitive_account.openai.primary_access_key
    DB_HOST                          = azurerm_postgresql_flexible_server.translator_db.fqdn
    DB_PORT                          = 5432
    DB_NAME                          = azurerm_postgresql_flexible_server_database.citus_db.name
    DB_USER                          = azurerm_postgresql_flexible_server.translator_db.administrator_login
    DB_PASSWORD                      = random_password.db_password.result
    DB_SSLMODE                       = "require"
  }

  #   zip_deploy_file = "./document_translate_function.zip"
  tags = local.default_tags

  provisioner "local-exec" {
    command = "az functionapp deployment source config-zip --resource-group ${azurerm_resource_group.rg.name} --name ${local.name_prefix}-${var.function_app_name_translate}-${random_string.unique.result} --src ${data.archive_file.document_translate_function_zip.output_path} --build-remote true "
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

