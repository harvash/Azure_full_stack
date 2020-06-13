 providers.tf
# Resource definitions for providers

# Configure the Microsoft Azure Resource Manager provider
provider "azurerm" {
  version = ">= 2.0.0"
  features {}
  subscription_id = var.azure_sub_id
  tenant_id       = var.azure_tenant_id

  # Allows to access the subscription resource group through a service principal
  #
  client_id     = var.azure_client_id
  client_secret = var.azure_client_secret

  skip_provider_registration  = true
}

# Configure the Microsoft Azure Active Directory provider
provider "azuread" {
  version = "= 0.4.0"

  subscription_id = var.azure_sub_id
  tenant_id       = var.azure_tenant_id

  # Allows to access the subscription resource group through a service principal
  #
  client_id     = var.azure_client_id
  client_secret = var.azure_client_secret
}

# provider "random" {
#   version = ">= 2.1"
# }

# provider "null" {
#   version = ">= 2.1"
# }

# Retrieve details for the subscription
data "azurerm_subscription" "subscription" {}
