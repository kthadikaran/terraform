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

#IP Address range for azure k8s subnet
resource "azurerm_subnet" "terraformak8s-subnet01" {
  name                 = "terraformaksk8ssubnet01"
  virtual_network_name = azurerm_virtual_network.terraformak8s-vnet.name
  resource_group_name  = azurerm_resource_group.terraformak8s-rg02.name
  address_prefixes     = ["10.1.1.0/20"]
}

#IP Address range for firewall subnet
resource "azurerm_subnet" "terraformak8s-firewall-subnet01" {
  name                 = "terraformaksk8sfwsubnet01"
  virtual_network_name = azurerm_virtual_network.terraformak8s-vnet.name
  resource_group_name  = azurerm_resource_group.terraformak8s-rg02.name
  address_prefixes     = ["10.1.60.0/20"]
}

#Public IP Address for firewall
resource "azurerm_public_ip" "terraformak8s-firewall-pip01" {
  name                 = "terraformak8sfirewallpip01"
  virtual_network_name = azurerm_virtual_network.terraformak8s-vnet.name
  resource_group_name  = azurerm_resource_group.terraformak8s-rg02.name
  allocation_method    = "Static"
  sku                  = "Standard"
}
resource "azurerm_firewall" "base" {
  name                 = "fw-${local.name_prefix}-${local.environment}-${local.region}"
  virtual_network_name = azurerm_virtual_network.terraformak8s-vnet.name
  resource_group_name  = azurerm_resource_group.terraformak8s-rg02.name

  ip_configuration {
    name                 = "ip-${local.name_prefix}-${local.environment}-${local.region}"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.terraformak8s-firewall-pip01.id
  }
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

#Below Terraform block of code create managed azure Kubernetes cluster.
resource "azurerm_kubernetes_cluster" "terraformak8s-cluster01" {
  name                = "terraformak8scls01"
  resource_group_name = azurerm_resource_group.terraformak8s-rg02.name
  location            = azurerm_resource_group.terraformak8s-rg02.location
  kubernetes_version  = "1.20.9"
  dns_prefix          = "terraformak8scls01"

  #The default node pool is the first node pool in the cluster one that is being created at the time of creating the cluster you must need this otherwise Azure won’t allow you to create AKS. 
  default_node_pool {
    name                = "lnznpool"
    availability_zones  = [1, 2, 3]
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3 #Recommended count for production environment
    vm_size             = "Standard_D2_v2"
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "dev"
      "nodepoolsos"   = "linux"
      "app"           = "system-apps"
    }
    vnet_subnet_id = azurerm_subnet.terraformak8s-subnet01.id

    #Kubernetes cluster authentication and authorization method.
    #Authentication and authorization are used by the Kubernetes cluster to control user access to the cluster as well as what the user may do once authenticated.
    identity {
      type = "SystemAssigned"
    }
    role_based_access_control {
      enabled = true
      # azure_active_directory {
      #   managed                = true
      #   admin_group_object_ids = [azuread_group.aks_administrators.id]
      # }
    }
    linux_profile {
      admin_username = "ubuntu"
      ssh_key {
        key_data = data.azurerm_key_vault_secret.example.value
      }
    }
    #Azure-cni advanced networking for kubernetes clusters.
    network_profile {
      network_plugin     = "azure"
      load_balancer_sku  = "standard"
      network_policy     = "calico"
      service_cidr       = "10.2.0.0/16"
      dns_service_ip     = "10.2.0.10"
      docker_bridge_cidr = "172.17.0.1/16"
    }
    #Kubernetes cluster nodes administrator access
    tags = {
      name        = "terraformaksk8scls01"
      environment = "development"
      owner       = "demo@local.com"
    }
  }
}
