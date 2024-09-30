# Description: This Terraform configuration file creates an Azure Cognitive Services account for Azure AI Translation
# Cognitive Services account for Azure AI Translation
resource "azurerm_cognitive_account" "translator" {
  name                = "${var.translation_service_name}-${random_string.unique.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "TextTranslation"
  sku_name            = var.translation_sku

  custom_subdomain_name = "${var.translation_service_name}-${random_string.unique.result}"

  tags = local.default_tags
}
