resource "azurerm_subnet" "app_subnet" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.cidr]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"  # Required name for Bastion host subnet
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.2.0/24"]  # Different CIDR block from the app subnet
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}
