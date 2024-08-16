# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
module "vnet" {
  source              = "../../modules/vnet"
  name                = "dev-vnet"
  cidr                = var.vnet_cidr
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet for Bastion Host
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"  # Must be exactly this name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = [var.bastion_subnet_cidr]
}

# Subnet for Frontend VMSS
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "frontend-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = [var.frontend_subnet_cidr]
}

# Subnet for Backend VMSS
resource "azurerm_subnet" "backend_subnet" {
  name                 = "backend-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = [var.backend_subnet_cidr]
}

# Public IP for Frontend Load Balancer
resource "azurerm_public_ip" "frontend_lb_public_ip" {
  name                = "frontend-lb-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Frontend Load Balancer with Public IP
module "frontend_load_balancer" {
  source              = "../../modules/load_balancer"
  lb_name             = "frontend-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  public_ip_id        = azurerm_public_ip.frontend_lb_public_ip.id
}

# Backend Load Balancer (Internal) without Public IP
resource "azurerm_lb" "backend_lb" {
  name                = "backend-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "backend-lb-frontend"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Backend Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "backend_lb_pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.backend_lb.id

  depends_on = [azurerm_lb.backend_lb]
}

# Frontend VMSS with Password Authentication
module "frontend_vmss" {
  source              = "../../modules/vmss"
  vmss_name           = "frontend-vmss"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  subnet_id           = azurerm_subnet.frontend_subnet.id
  lb_backend_pool_id  = module.frontend_load_balancer.lb_backend_pool_id
  # custom_data         = file("${path.module}/../../scripts/install_nginx.sh")  # Pass the script content
  custom_data         = base64encode(file("${path.module}/../../scripts/install_nginx.sh"))  # Base64 encode the script
}

# Backend VMSS with Password Authentication
module "backend_vmss" {
  source              = "../../modules/vmss"
  vmss_name           = "backend-vmss"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  subnet_id           = azurerm_subnet.backend_subnet.id
  lb_backend_pool_id  = azurerm_lb_backend_address_pool.backend_lb_pool.id
  custom_data         = base64encode(file("${path.module}/../../scripts/install_python.sh"))  # Base64 encode the script
}

# SQL Database
module "sql_database" {
  source              = "../../modules/sql_database"
  name                = "dev-sql-database"
  admin_username      = var.sql_admin_username
  admin_password      = var.sql_admin_password
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Bastion Host
module "bastion_host" {
  source              = "../../modules/bastion_host"
  vnet_name           = module.vnet.name
  subnet_id           = azurerm_subnet.bastion_subnet.id
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}
