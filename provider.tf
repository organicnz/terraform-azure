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

  # required_plugins {
  #   azurerm = {
  #     source = "hashicorp/azurerm"
  #   }
  # }
}

provider "azurerm" {

  skip_provider_registration = true

  // To create secrets use "az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>""
  // With name "az ad sp create-for-rbac --name "vpngermany_terraform_app" --role="Contributor" --scopes="/subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc""
  subscription_id = "f8368c46-055d-4b25-b4d4-7410f92cb8bc"
  client_id       = "f10e8212-05fc-4409-85ff-52bb23d6cf38"
  client_secret   = "fST8Q~zzkCKoX2w0ZDuDeIh_-oHYR1lVEPUXvcw1"
  tenant_id       = "f107b5bb-3869-4b6e-844e-d9cc0dcb36a0"

  # subscription_id = "f8368c46-055d-4b25-b4d4-7410f92cb8bc"

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