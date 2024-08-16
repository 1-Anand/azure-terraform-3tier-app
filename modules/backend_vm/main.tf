# resource "azurerm_virtual_machine" "vm" {
#   name                  = var.vm_name
#   location              = var.location
#   resource_group_name   = var.resource_group_name
#   network_interface_ids = [var.network_interface_id]
#   vm_size               = var.vm_size

#   storage_os_disk {
#     name              = "${var.vm_name}-osdisk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_profile {
#     computer_name  = var.vm_name
#     admin_username = var.admin_username
#     admin_password = var.admin_password
#     custom_data    = file("${path.module}/../../scripts/install_python.sh")
#   }

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

#   connection {
#     type        = "ssh"
#     user        = var.admin_username
#     password    = var.admin_password
#     host        = var.network_interface_private_ip
#     timeout     = "15m"
#   }
# }
