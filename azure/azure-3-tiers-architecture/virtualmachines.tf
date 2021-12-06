resource "tls_private_key" "teformdemowebssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" {
  value = "tls_private_key.teformdemowebssh.linuxwebserver01pem" 
  }

resource "azurerm_linux_virtual_machine" "teformdemowebvm" {
  name                = "teformdemo001webvm"
  resource_group_name = azurerm_resource_group.teformdemorg.name
  location            = "West US"
  size                = "Standard_F2"
  network_interface_ids = [
    azurerm_network_interface.teformdemowebnic.id,
  ]     
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "teformdemo001webvm"
  admin_username = "azureuser"
  disable_password_authentication = true
  admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.teformdemowebssh.public_key_openssh
    }
}