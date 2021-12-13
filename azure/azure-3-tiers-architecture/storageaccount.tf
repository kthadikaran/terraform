#Ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "teformdemostrac" {
    name                        = "teformdemo001stac"
    resource_group_name = azurerm_resource_group.teformdemorg.name 
    location 		            = "West US"
    account_replication_type    = "LRS"
    account_tier                = "Standard"
    tags = {
        environment = "terraformdemo"
    }
}
