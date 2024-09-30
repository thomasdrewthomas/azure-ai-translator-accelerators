#terraform plan -out main.tfplan
#terraform apply "main.tfplan"
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}-${var.resource_group_name}"
  location = var.location
  tags     = local.default_tags

}


# Storage Account
resource "azurerm_storage_account" "storage" {
  name                      = "tf${var.storage_account_name}${var.environment}${random_string.unique.result}"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  shared_access_key_enabled = true

  tags = local.default_tags
}

# Storage Container
resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}


data "azurerm_storage_account_sas" "storage_sas_token" {
  depends_on = [azurerm_storage_account.storage]
  connection_string = azurerm_storage_account.storage.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = var.sas_start_date
  expiry = var.sas_expiry_date

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
    tag     = true
    filter  = true
  }
}