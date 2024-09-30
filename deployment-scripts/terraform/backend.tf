terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraform19831233"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}