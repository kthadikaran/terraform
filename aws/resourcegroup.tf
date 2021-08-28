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