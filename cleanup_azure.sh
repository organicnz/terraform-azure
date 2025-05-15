#!/bin/bash

# Azure Resource Cleanup Script
# This script provides a step-by-step process to examine, plan, and delete Azure resources

# Function to check if Azure CLI is installed and logged in
check_azure_cli() {
  echo "Checking Azure CLI installation and login status..."
  if ! command -v az &> /dev/null; then
    echo "Azure CLI is not installed. Please install it before running this script."
    exit 1
  fi

  # Check if logged in
  if ! az account show &> /dev/null; then
    echo "You are not logged into Azure. Please log in first."
    az login
  fi

  echo "Azure CLI is installed and you are logged in."
  echo "Subscription: $(az account show --query name -o tsv)"
  echo "---------------------------------------------"
}

# Function to list all resource groups
list_resource_groups() {
  echo "Listing all resource groups in your subscription:"
  az group list --output table
  echo "---------------------------------------------"
}

# Function to examine resources in a resource group
examine_resource_group() {
  local rg_name=$1
  
  echo "Examining resources in resource group: $rg_name"
  az resource list --resource-group "$rg_name" --output table
  echo "---------------------------------------------"
}

# Function to delete a resource group
delete_resource_group() {
  local rg_name=$1
  
  echo "Deleting resource group: $rg_name"
  echo "This action will delete ALL resources in the resource group!"
  read -p "Are you sure you want to proceed? (y/n): " confirm
  
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "Proceeding with deletion..."
    az group delete --name "$rg_name" --yes
    echo "Resource group deletion initiated."
  else
    echo "Deletion cancelled."
  fi
  echo "---------------------------------------------"
}

# Main script execution
check_azure_cli

echo "Azure Resource Cleanup Utility"
echo "==============================="
echo "This script helps you examine and delete Azure resources."
echo ""

while true; do
  echo "Select an option:"
  echo "1. List all resource groups"
  echo "2. Examine resources in a specific resource group"
  echo "3. Delete a specific resource group"
  echo "4. Exit"
  read -p "Enter your choice (1-4): " choice
  
  case $choice in
    1)
      list_resource_groups
      ;;
    2)
      read -p "Enter resource group name to examine: " rg_name
      examine_resource_group "$rg_name"
      ;;
    3)
      read -p "Enter resource group name to delete: " rg_name
      delete_resource_group "$rg_name"
      ;;
    4)
      echo "Exiting."
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac
done 