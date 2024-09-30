resource "azurerm_cognitive_account" "openai" {
  resource_group_name           = azurerm_resource_group.rg.name
  custom_subdomain_name         = "${local.name_prefix}-openai-${random_string.unique.result}"
  kind                          = "OpenAI"
  local_auth_enabled            = true
  location                      = var.openai_location
  name                          = "${local.name_prefix}-openai"
  public_network_access_enabled = true
  sku_name                      = var.openai_sku
  tags                          = local.default_tags
  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_cognitive_deployment" "gpt_4o" {
  for_each               = {for deployment in var.openai_deployments : deployment.name => deployment}
  cognitive_account_id   = azurerm_cognitive_account.openai.id
  name                   = each.key
  version_upgrade_option = "OnceNewDefaultVersionAvailable"

  model {
    format  = each.value.model.format
    name    = each.value.model.name
    version = each.value.model.version
  }

  scale {
    capacity = each.value.scale.capacity
    type     = each.value.scale.type
  }

}

resource "azurerm_monitor_diagnostic_setting" "settings" {
  name                       = "${local.name_prefix}-openai-diagnostic"
  target_resource_id         = azurerm_cognitive_account.openai.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  metric {
    category = "AllMetrics"
  }

  enabled_log {
    category = "Audit"
  }

  enabled_log {
    category = "RequestResponse"
  }

  enabled_log {
    category = "Trace"
  }


}


output "openai_deployment_dev_id" {
  value = azurerm_cognitive_deployment.gpt_4o["dev"].id
}
