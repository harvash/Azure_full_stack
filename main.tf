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

resource "azurerm_storage_account" "sa" {
  name                = "${var.prefix}sa${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.UMLfulStackRG.name
  location            = "eastus"

  account_kind             = "StorageV2"
  account_tier             = "Premium"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "container" {
  name                  = "${var.prefix}-storage-container"
  container_access_type = "private"
  storage_account_name  = azurerm_storage_account.sa.name
}

