terraform {
  backend "azurerm" {
    resource_group_name  = "azterraformpipeline-rg"
    storage_account_name = "tfbkstorageaccount"
    container_name       = "tfbkstoragecon"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  version = "=2.20.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "teformdemorg" {
  name = "teformdemo001_rg"
  location = var.location
  tags = {
    environment = "teformdemo"
  }
}
