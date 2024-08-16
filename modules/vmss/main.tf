resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.vm_size
  instances           = var.initial_instance_count
  admin_username      = var.admin_username
  admin_password      = var.admin_password  # Ensure password is provided
  disable_password_authentication = false   # Disable SSH key-only access

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  upgrade_mode = "Automatic"

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name                          = "internal"
      subnet_id                     = var.subnet_id
      primary                       = true
      load_balancer_backend_address_pool_ids = [var.lb_backend_pool_id]
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = var.custom_data  # Pass custom data here
}
