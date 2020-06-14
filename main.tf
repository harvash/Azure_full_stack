#  Main definitions for our Azure_full_stack VM creation

# # For creating some random strings
resource "random_string" "random" {
  length  = 6
  upper   = false
  special = false
  #override_special = "/@£$"
}

# Used for storing diagnostic data
resource "azurerm_storage_account" "UMLfullStackSA" {
  name                = "${var.prefix}sa${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.UMLfullStackRG.name
  location            = "eastus"
  account_tier        = "Standard"
  account_replication_type = "LRS"
  
  tags = {
    UMLProject = "FullStack"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "UMLfullStackVM" {
  name                  = "umlapp01"
  location              = "eastus"
  resource_group_name   = data.azurerm_resource_group.UMLfullStackRG.name
  network_interface_ids = [data.azurerm_network_interface.UMLfullStackNIC.id]
  vm_size               = "Standard_B1s"
  
  os_profile {
    computer_name     = "umlapp01"
    admin_username    = var.vm_admin_name    
  }
  
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("./id_rsa.pub")
      path     = "/home/${var.vm_admin_name}/.ssh/authorized_keys"
    }
  }
  
  storage_os_disk {
    name              = "${var.prefix}-disk01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 30 
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    enabled               = true
    storage_uri = azurerm_storage_account.UMLfullStackSA.primary_blob_endpoint
  }

  tags = {
      UMLProject = "FullStack"
  }
}