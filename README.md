# Azure Infrastructure with Terraform

This repository contains Terraform configurations for deploying and managing infrastructure in Microsoft Azure.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Installing Terraform on Linux](#installing-terraform-on-linux)
  - [Installing Terraform on Windows](#installing-terraform-on-windows)
  - [Installing Azure CLI](#installing-azure-cli)
- [Azure Account Setup](#azure-account-setup)
  - [Setting up Authentication](#setting-up-authentication)
  - [Creating Service Principal](#creating-service-principal)
- [Working with Terraform](#working-with-terraform)
  - [Project Structure](#project-structure)
  - [Provider Configuration](#provider-configuration)
  - [Resource Configuration](#resource-configuration)
  - [Using Variables](#using-variables)
  - [SSH Key Configuration](#ssh-key-configuration)
- [Workflow](#workflow)
  - [Initialize](#initialize)
  - [Validate](#validate)
  - [Plan](#plan)
  - [Apply](#apply)
  - [Destroy](#destroy)
- [Example Resources](#example-resources)
  - [Resource Group](#resource-group)
  - [Virtual Network & Subnet](#virtual-network--subnet)
  - [Virtual Machine](#virtual-machine)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## Overview

Terraform is an Infrastructure as Code (IaC) tool that allows you to define and provision cloud infrastructure using a declarative configuration language. When configuration files are changed, Terraform automatically determines the actions needed to achieve the desired state and executes them accordingly.

This repository provides templates and instructions for using Terraform to create and manage resources in Microsoft Azure.

## Prerequisites

- An Azure subscription
- Basic understanding of cloud infrastructure concepts
- Command line/terminal experience

## Installation

### Installing Terraform on Linux

```bash
# Update package list
sudo apt update

# Install required packages
sudo apt install -y wget unzip

# Download Terraform (replace X.Y.Z with the latest version)
wget https://releases.hashicorp.com/terraform/X.Y.Z/terraform_X.Y.Z_linux_amd64.zip

# Extract the archive
unzip terraform_X.Y.Z_linux_amd64.zip

# Move to a directory in your PATH
sudo mv terraform /usr/local/bin/

# Verify installation
terraform -v
```

You can find the latest version of Terraform at [releases.hashicorp.com/terraform](https://releases.hashicorp.com/terraform/).

### Installing Terraform on Windows

Using Chocolatey (recommended):

```bash
# Install Chocolatey (run in PowerShell as Administrator)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Terraform
choco install terraform

# Verify installation
terraform -v
```

Alternatively, you can manually download and install Terraform from the [official website](https://www.terraform.io/downloads.html).

### Installing Azure CLI

The Azure CLI is required to interact with your Azure subscription:

```bash
# For Linux (Ubuntu/Debian)
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# For Windows (using PowerShell)
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
```

## Azure Account Setup

### Setting up Authentication

Login to Azure CLI:

```bash
az login
```

Set your subscription:

```bash
az account set -s <SUBSCRIPTION_ID>
```

### Creating Service Principal

Create a service principal for Terraform to use:

```bash
# Create a service principal with Contributor role
az ad sp create-for-rbac --name "terraform-sp-name" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

The command will output JSON containing:
- `appId` (maps to client_id)
- `password` (maps to client_secret)
- `tenant` (maps to tenant_id)

Store these values securely for use in your Terraform configuration.

## Working with Terraform

### Project Structure

A typical Terraform project structure:

```
terraform-azure/
├── main.tf          # Main configuration file
├── variables.tf     # Variable declarations
├── terraform.tfvars # Variable values (gitignored)
├── outputs.tf       # Output definitions
└── README.md        # Documentation
```

### Provider Configuration

Configure the Azure provider in your Terraform files:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  # Use Azure CLI authentication or service principal
  # If using service principal:
  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
}
```

### Resource Configuration

Define Azure resources using Terraform's declarative syntax:

```hcl
# Example: Creating a resource group
resource "azurerm_resource_group" "example" {
  name     = "azure-resources"
  location = "eastus"
  tags = {
    environment = "Development"
  }
}
```

### Using Variables

Define variables in `variables.tf`:

```hcl
variable "location" {
  description = "The Azure region to deploy resources to"
  type        = string
  default     = "eastus"
}

variable "instance_name" {
  description = "Name for the VM instance"
  type        = string
}
```

Set values in `terraform.tfvars` (add to .gitignore for sensitive data):

```hcl
location      = "eastus"
instance_name = "azure-server"
```

### SSH Key Configuration

For VMs that use SSH authentication:

```hcl
# In your VM resource
os_profile_linux_config {
  disable_password_authentication = true
  ssh_keys {
    path     = "/home/username/.ssh/authorized_keys"
    key_data = var.ssh_public_key
  }
}
```

## Workflow

### Initialize

Initialize your Terraform working directory:

```bash
terraform init
```

This downloads providers and sets up the backend.

### Validate

Validate your configuration:

```bash
terraform validate
```

### Plan

Preview the changes Terraform will make:

```bash
terraform plan
```

Save the plan to a file for later use:

```bash
terraform plan -out=tfplan
```

### Apply

Apply the changes to create/update infrastructure:

```bash
terraform apply
```

Or apply a saved plan:

```bash
terraform apply tfplan
```

You'll need to confirm by typing `yes` unless you use the `-auto-approve` flag.

### Destroy

Remove all resources managed by Terraform:

```bash
terraform destroy
```

## Example Resources

### Resource Group

```hcl
resource "azurerm_resource_group" "main" {
  name     = "azure-resources"
  location = var.location
}
```

### Virtual Network & Subnet

```hcl
resource "azurerm_virtual_network" "main" {
  name                = "azure-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
```

### Virtual Machine

```hcl
resource "azurerm_linux_virtual_machine" "main" {
  name                = "azure-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]
  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
```

## Troubleshooting

- **Authentication Issues**: Verify your service principal has the correct permissions
- **Naming Conventions**: Azure has specific naming rules for different resources
- **Resource Locks**: Check for any locks preventing resource modifications
- **Quota Limits**: Ensure your subscription has sufficient quota for the resources you're creating

## Resources

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [Azure Naming Conventions](https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions)