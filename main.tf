#  Main definitions for our Azure_full_stack VM creation

# # For creating some random strings
resource "random_string" "random" {
  length  = 6
  upper   = false
  special = false
  #override_special = "/@£$"
}

# # Create public IPs
resource "azurerm_public_ip" "UMLfullStackPID" {
    name                         = "UMLfullStackPID"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.UMLfullStackRG.name
    allocation_method            = "Dynamic"

    tags = {
        UMLProject = FullStack
    }
}

# Used for storing diagnostic data
resource "azurerm_storage_account" "UMLfullStackSA" {
  name                = "${var.prefix}sa${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.UMLfulStackRG.name
  location            = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = {
    UMLProject = FullStack
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "UMLfullStackVM" {
    name                  = "umlapp01"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.UMLfullStackRG.name
    network_interface_ids = [azurerm_network_interface.UMLfullStackNIC.id]
    size                  = "Standard_B1s"

    os_disk {
        name              = "${var.prefix}-disk01"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }
  os_profile {
    computer_name  = "umlapp01"
    admin_username = var.vm_admin_name
  } 
  
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("./id_rsa.pub")
      path     = "/home/${var.vm_admin_name}/.ssh/authorized_keys"

    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.UMLfullStackSA.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
}