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
  # backend "azurerm" {
  #   resource_group_name  = "tfstate"
  #   storage_account_name = "tfstatexuigermany"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
  # required_plugins {
  #   azurerm = {
  #     source = "hashicorp/azurerm"
  #   }
  # }
}

provider "azurerm" {
  skip_provider_registration = true
  
  # Using Azure CLI authentication - no need for explicit credentials
  # This will use the account from 'az login'
  use_cli = true
  
  features {
    key_vault {
      recover_soft_deleted_key_vaults = false
    }
  }
}

provider "azuread" {
  # Also using Azure CLI authentication
  use_cli = true
}

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