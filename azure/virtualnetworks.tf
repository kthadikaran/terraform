resource "azurerm_virtual_network" "teformdemovnet" {
    name                = "teformdemo001vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "West US"
    resource_group_name = azurerm_resource_group.teformdemorg.name

    tags = {
        environment = "terraformdemo"
    }
}

# Create WebserversSubnet
resource "azurerm_subnet" "teformdemosubnet01" {
    name                 = "teformdemo001subnet01"
    resource_group_name = azurerm_resource_group.teformdemorg.name
    virtual_network_name = azurerm_virtual_network.teformdemovnet.name
    address_prefixes = ["10.0.1.0/24"]
}

# Create AppServersSubnet
resource "azurerm_subnet" "teformdemosubnet02" {
    name                 = "teformdemo001subnet02"
    resource_group_name = azurerm_resource_group.teformdemorg.name
    virtual_network_name = azurerm_virtual_network.teformdemovnet.name
    address_prefixes = ["10.0.2.0/24"]
}

# Create DBServersSubnet
resource "azurerm_subnet" "teformdemosubnet03" {
    name                 = "teformdemo001subnet03"
    resource_group_name = azurerm_resource_group.teformdemorg.name
    virtual_network_name = azurerm_virtual_network.teformdemovnet.name
    address_prefixes = ["10.0.3.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "tedemoweb01pubip" {
    name                         = "web01publicip"
    location                     = var.location
    resource_group_name = azurerm_resource_group.teformdemorg.name
    allocation_method            = "Dynamic"
}


# Create Network Security Group Creation
resource "azurerm_network_security_group" "teformdemowebnsg" {
    name                = "teformdemo001web01nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.teformdemorg.name
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
        environment = "terraformdemo"
    }
}

# Create network interface
resource "azurerm_network_interface" "teformdemowebnic" {
  name                = "teformdemo001web01nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.teformdemorg.name
  ip_configuration {
    name                          = "teformdemo001web01nicfg"
    subnet_id                     = azurerm_subnet.teformdemosubnet01.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.tedemoweb01pubip.id
  }
}
resource "azurerm_network_interface_security_group_association" "teformdemowebnicnsg" {
  network_interface_id      = azurerm_network_interface.teformdemowebnic.id
  network_security_group_id = azurerm_network_security_group.teformdemowebnsg.id
}