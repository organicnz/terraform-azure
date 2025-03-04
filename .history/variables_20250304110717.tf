# Authentication variables are no longer needed with CLI authentication
# variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
# variable "tenant_id" {}

variable "environment" {}
variable "project_name" {}
# variable "network" {}
# variable "subnet" {}
# variable "public_ip" {}
# variable "network_interface" {}
# variable "ip_configuration" {}
# variable "virtual_machine" {}
# variable "vm_size" {}
# variable "storage_os_disk" {}
# variable "admin_username" {}
# variable "disk_size_gb" {}
# variable "azurerm_resource_group" {} 
# variable "location" {}  


# variable "subscription_id" {
#   type        = string
#   description = "Azure subscription ID"
# }

# variable "client_id" {
#   type        = string
#   description = "Azure AD application client ID"
# }

# variable "client_secret" {
#   type        = string
#   description = "Azure AD application client secret"
# }

# variable "tenant_id" {
#   type        = string
#   description = "Azure AD tenant ID"
# }


variable "instance_name" {
  type    = string
  default = "vpn_service"
}

variable "azurerm_resource_group" {
  type    = string
  default = "vpn_service_resource_group"
}

# locals {
#   azurerm_resource_group = "${var.instance_name}_resource_group"
# }

variable "key_data" {
  description = "SSH key data"
  type        = string
}

# Define other input variables here...

variable "network" {
  description = "Name of the network"
  type        = string
  default     = "vpn_service_network" # Provide a default value if necessary
}

variable "subnet" {
  description = "Name of the subnet"
  type        = string
  default     = "vpn_service_subnet" # Provide a default value if necessary
}

variable "public_ip" {
  description = "Name of the public IP"
  type        = string
  default     = "vpn_service_public_ip" # Provide a default value if necessary
}

variable "network_interface" {
  description = "Name of the network interface"
  type        = string
  default     = "vpn_service_network_interface" # Provide a default value if necessary
}

variable "ip_configuration" {
  description = "Name of the IP configuration"
  type        = string
  default     = "vpn_service_ip_configuration" # Provide a default value if necessary
}

variable "virtual_machine" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vpn_service_virtual_machine" # Provide a default value if necessary
}

variable "storage_os_disk" {
  description = "Name of the OS disk"
  type        = string
  default     = "vpn_service_storage_os_disk" # Provide a default value if necessary
}

variable "location" {
  description = "Location of the Azure resource group"
  type        = string
  default     = "Germany West Central" # Provide a default value if necessary: Germany West Central, UK South or West US
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
  default     = "vpn_service"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "vpn_service"
}