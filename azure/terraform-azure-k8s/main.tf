#Strongly recommended using the required_providers block to set the Azure Provider source and version being used.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-aks-k8s-rg01"
    storage_account_name = "terraformaksk8ssa01"
    container_name       = "tfstateaksk8s01"
    key                  = "terraform.tfstate"
  }
}

#A Terraform configuration file starts off with the specification of the provider.So configure the Microsoft Azure as Provider.
provider "azurerm" {
  features {}
}
