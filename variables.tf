# Azure Authentication Template
# Using Azure CLI authentication - no need for credential variables

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., production, staging, development)"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
}

# Network related variables are commented out but kept for reference
# variable "network" {}
# variable "subnet" {}
# variable "public_ip" {}
# variable "network_interface" {}
# variable "ip_configuration" {}
# variable "virtual_machine" {}
# variable "storage_os_disk" {}

variable "instance_name" {
  type        = string
  description = "Name of the VM instance"
}

variable "key_data" {
  description = "SSH key data for VM authentication"
  type        = string
}

variable "location" {
  description = "Location of the Azure resource group"
  type        = string
  default     = "Germany West Central"
}

variable "admin_username" {
  type        = string
  description = "The username for the virtual machine"
}

variable "disk_size_gb" {
  type        = number
  description = "The size of the OS disk in GB"
}

variable "vm_size" {
  type        = string
  description = "The size of the virtual machine"
}

variable "resource_group_name_prefix" {
  type        = string
  description = "Prefix for resource group name"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix for resource names"
}

# VM Operations
variable "deallocate_vms" {
  type        = bool
  description = "Whether to deallocate (stop) all VMs as part of the Terraform execution"
  default     = false
}