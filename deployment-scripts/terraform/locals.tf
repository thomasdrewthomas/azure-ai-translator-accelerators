locals {
  name_prefix = "${var.prefix}${var.name}-${var.environment}"


  default_tags = {
    Region          = var.location
    Environment     = var.environment
    Owner           = "AI-TEAM"
    Project         = "AI-TRANSLATOR"
    Stage           = "TRANSLATION-SERVICE"
    ManagedBy       = "TERRAFORM"
    CostCenter      = "AI-TEAM"
    client_id       = data.azurerm_client_config.current.client_id
    tenant_id       = data.azurerm_client_config.current.tenant_id
    subscription_id = data.azurerm_client_config.current.subscription_id
    object_id       = data.azurerm_client_config.current.object_id
  }
}