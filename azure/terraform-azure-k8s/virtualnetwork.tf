# Your Terraform code for resource deployment starts from here.
#Create a resource group in Azure subscription
resource "azurerm_resource_group" "terraformak8s-rg02" {
  name     = "terraform-aks-k8s-rg02"
  location = "westeurope"
  tags = {
    name        = "terraform-aks-k8s-rg02"
    environment = "development"
    owner       = "demo@local.com"
  }
}

#Create DDoS Protecttion plan for AKS K8S Virtual network.
resource "azurerm_network_ddos_protection_plan" "terraformak8s-ddos-plan01" {
  name                = "terraformaksk8sddos01"
  location            = azurerm_resource_group.terraformak8s-rg02.location
  resource_group_name = azurerm_resource_group.terraformak8s-rg02.name
}

#Create Network Security Group for AKS K8S Virtual network
resource "azurerm_network_security_group" "terraformak8s-nsg01" {
  name                = "tarraformaksk8snsg01"
  location            = azurerm_resource_group.terraformak8s-rg02.location
  resource_group_name = azurerm_resource_group.terraformak8s-rg02.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    name        = "tarraformaksk8snsg01"
    environment = "development"
    owner       = "demo@local.com"
  }
}

#Below Terraform block of codes create the Azure VNet and subnet, which are required for the Azure CNI network
#implementation

resource "azurerm_virtual_network" "terraformak8s-vnet" {
  name                = "terraformaksk8svnet01"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.terraformak8s-rg02.location
  resource_group_name = azurerm_resource_group.terraformak8s-rg02.name
  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.terraformak8s-ddos-plan01.id
    enable = true
  }
  tags = {
    name        = "terraformaksk8svnet01"
    environment = "development"
    owner       = "demo@local.com"
  }
}

resource "azurerm_subnet" "terraformak8s-subnet01" {
  name                 = "terraformaksk8ssubnet01"
  virtual_network_name = azurerm_virtual_network.terraformak8s-vnet.name
  resource_group_name  = azurerm_resource_group.terraformak8s-rg02.name
  address_prefixes     = ["10.1.0.0/16"]
}

#User defined routable for terraform azure k8s cluster
resource "azurerm_route_table" "terraformak8s-rtb01" {
  name                = "terraformaksk8srtb01"
  location            = azurerm_resource_group.terraformak8s-rg02.location
  resource_group_name = azurerm_resource_group.terraformak8s-rg02.name

  route {
    name                   = "terraformak8s-cluster01"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }

  route {
    name           = "default-route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualNetworkGateway"
  }
}
resource "azurerm_subnet_route_table_association" "cluster-01" {
  subnet_id      = azurerm_subnet.terraformak8s-subnet01.id
  route_table_id = azurerm_route_table.terraformak8s-rtb01.id
}

#Terraform code for new key vault creation to access nodes in aks cluster system.
data "azurerm_key_vault_secret" "example" {
  name         = "ssh-key-linux-profile"
  key_vault_id = "/subscriptions/6a775481-949a-498b-ae84-a2265a6dd1f4/resourceGroups/terraform-aks-k8s-rg01/providers/Microsoft.KeyVault/vaults/terraformaksclslnxnkv01"
}
