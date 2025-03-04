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

provider "azurerm" {

  skip_provider_registration = true

  // To create secrets use "az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>""
  // With a name "az ad sp create-for-rbac --name "vpn_service_terraform_app" --role="Contributor" --scopes="/subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc""
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

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