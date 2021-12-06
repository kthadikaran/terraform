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
    
    network_security_group {
      name                = "exampleAksSecurityGroup"
       resource_group_name = azurerm_resource_group.terraformak8s-rg02.name
       location            = azurerm_resource_group.terraformak8s-rg02.location
        security_rule {
          name                       = "allowAllTcp"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
  }
  #Kubernetes cluster authentication and authorization method.
  #Authentication and authorization are used by the Kubernetes cluster to control user access to the cluster
  #as well as what the user may do once authenticated.
  service_principal {
    client_id     = "87a1f1d2-cdb3-4245-a185-9323446dd953"
    client_secret = "c0y7Q~c59EjbGCgZXwX8QCi-WdX94kv1t23M-"
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
