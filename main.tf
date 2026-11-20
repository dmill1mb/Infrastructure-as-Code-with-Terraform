# Use the Azure provider, any 3.x version.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# The provider needs a features block, even when it is empty.
provider "azurerm" {
  features {}
}

# 1. Resource group. Change demarcus to your own name.
resource "azurerm_resource_group" "rg" {
  name     = "rg-lab04-tf-demarcus"
  location = "Central US"
}

# 2. Virtual network. It reads the group's name and location, so Terraform
#    knows to build the group first.
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# 3. Subnet. 10.0.1.0/24 is a slice of the network's 10.0.0.0/16 range.
resource "azurerm_subnet" "subnet" {
  name                 = "snet-backend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# 4. Network security group. It starts with no rules of your own.
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-web"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}