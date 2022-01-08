terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  remote_ipaddress = csvdecode(file("./IPAddress.csv"))
}

output "remoteip" {
  value=local.remote_ipaddress[*].IPAddress
}

Sample CSV File

IPAddress
45.45.65.42
97.45.98.76
56.123.55.67
75.12.65.42
34.43.34.76
32.123.54.67
