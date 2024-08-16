variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
}

variable "vnet_cidr" {
  description = "The CIDR block for the virtual network"
  type        = string
}

variable "bastion_subnet_cidr" {
  description = "The CIDR block for the Bastion Host subnet"
  type        = string
}

variable "frontend_subnet_cidr" {
  description = "The CIDR block for the Frontend VMSS subnet"
  type        = string
}

variable "backend_subnet_cidr" {
  description = "The CIDR block for the Backend VMSS subnet"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machines"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machines"
  type        = string
  sensitive   = true
}

variable "sql_admin_username" {
  description = "Admin username for the SQL database"
  type        = string
}

variable "sql_admin_password" {
  description = "Admin password for the SQL database"
  type        = string
  sensitive   = true
}
