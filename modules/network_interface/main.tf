resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

output "id" {
  value = azurerm_network_interface.nic.id
}

output "private_ip_address" {
  value = azurerm_network_interface.nic.private_ip_address
}
