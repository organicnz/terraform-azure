#!/bin/bash

# Ask for confirmation before proceeding
echo "WARNING: This script will clean up all local Terraform state files."
echo "This will not affect your Azure resources, but you will lose your local Terraform state."
read -p "Are you sure you want to continue? (yes/no): " confirmation

if [[ $confirmation != "yes" ]]; then
  echo "Operation canceled."
  exit 0
fi

# Remove Terraform state files
rm -f terraform.tfstate 
rm -f terraform.tfstate.backup
rm -f .terraform.lock.hcl
rm -f main.tfplan

# Delete the .terraform directory
rm -rf .terraform

# Remove generated plan files
rm -f terraform.plan
rm -f *.tfplan

# Delete backup files
rm -f *.backup

echo "Cleanup completed! Terraform state has been reset."
