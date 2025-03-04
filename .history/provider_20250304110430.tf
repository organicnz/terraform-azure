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

  # No need to specify these values as they will be read from environment variables:
  # ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id

  features {
    key_vault {
      recover_soft_deleted_key_vaults = false
    }
  }
}

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