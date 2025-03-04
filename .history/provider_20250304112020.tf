# Specify the version of the AzureRM Provider to use
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
  # Uncomment this block if you want to use remote state
  # backend "azurerm" {
  #   resource_group_name  = "tfstate"
  #   storage_account_name = "tfstatevpn_service"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
  # required_plugins {
  #   azurerm = {
  #     source = "hashicorp/azurerm"
  #   }
  # }
}

# Configure Azure Resource Manager provider to use Azure CLI authentication
provider "azurerm" {
  skip_provider_registration = true
  # Using Azure CLI authentication
  # Run 'az login' before running Terraform commands
  features {
    key_vault {
      recover_soft_deleted_key_vaults = false
    }
  }
}

# Configure Azure Active Directory provider
provider "azuread" {}

# Must be commented out. This is only for troubleshooting purposes. 
# output "pub_key_value" {
#   value = var.pub_key
# }

# output "pvt_key_value" {
#   value = var.public_ip
# }

# output "ssh_fingerprint_value" {
#   value = var.ssh_fingerprint
# }

# output "instance_name_value" {
#   value = var.instance_name
# }