variable "vmss_name" {
  description = "The name of the VM scale set"
  type        = string
}

variable "location" {
  description = "The Azure location where the VM scale set will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machines"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the VM scale set"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the VM scale set"
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "The subnet ID where the VM scale set will be deployed"
  type        = string
}

variable "lb_backend_pool_id" {
  description = "The load balancer backend pool ID"
  type        = string
}

variable "initial_instance_count" {
  description = "The initial number of instances in the VM scale set"
  type        = number
  default     = 1
}

variable "custom_data" {
  description = "Custom data (startup script) to be passed to the VM"
  type        = string
  default     = ""
}
