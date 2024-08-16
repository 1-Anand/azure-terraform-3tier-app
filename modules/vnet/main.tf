resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  address_space       = [var.cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
}

output "name" {
  value = azurerm_virtual_network.vnet.name
}
