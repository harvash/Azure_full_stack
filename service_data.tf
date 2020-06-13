# The following data calls will gather information about existing services.
# This is useful in a production (and even development) environments where some services are
# typically provisioned by another group, like networking or security services
#
# The data adatpers here assume the following services have already been provisioned and that the user
# has proper access via owner role or service principal:
#  Resource Group
#  Networking:  Virtual Network, Subnets, NSG & NIC
#  

data "azurerm_resource_group" "UMLfullStackRG" {
  name = "UMLfullStackrg"
}

output "id" {
  value = data.azurerm_resource_group.UMLfullStackRG.id
}

data "azurerm_virtual_network","UMLfullStackNet" {
  name = "UMLfullStackNet"
  resource_group_name = azurerm_resource_group.UMLfullStackRG.name
  
output "virtual_network_id" {
  value = data.azurerm_virtual_network.UMLfullStackNet.id
}

data "azurerm_subnet","UMLfullStackSubnet" {
  name = "UMLfullStackSubnet"
  resource_group_name = azurerm_resource_group.UMLfullStackRG.name
}

output "subnet_id" {
  value = azurerm_subnet.UMLfullStackSubnet
}


data "azurerm_network_security_group" "UMLfullStackNSG" {
  name                = "UMLfullStackNSG"
  resource_group_name = azurerm_resource_group.UMLfullStackRG.name
}

output "network_security_group_id" {
  value = data.azurerm_network_security_group.UMLfullStackRG.location
}

data "azurerm_network_interface" "UMLfullStackNIC" {
  name                = "UMLfullStackNIC"
  resource_group_name = azurerm_resource_group.UMLfullStackRG.name
}

output "network_interface_id" {
  value = data.azurerm_network_interface.UMLfullStackNIC.id
}



