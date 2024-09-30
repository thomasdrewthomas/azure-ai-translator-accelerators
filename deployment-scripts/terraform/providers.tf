provider "azurerm" {
  features {}
  storage_use_azuread = true

  subscription_id = var.subscription_id
}

provider "random" {}
provider "archive" {}