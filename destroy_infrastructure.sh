#!/bin/bash
# Script to destroy all Azure infrastructure managed by Terraform

echo "WARNING: This script will DESTROY ALL RESOURCES in your Azure subscription that are managed by Terraform."
echo "This action is irreversible and will result in data loss."
read -p "Are you sure you want to continue? (yes/no): " confirmation

if [[ $confirmation != "yes" ]]; then
  echo "Operation canceled."
  exit 0
fi

echo "First, let's make sure you're logged into Azure..."
az login

echo "Now, let's destroy all Azure resources managed by Terraform..."
terraform destroy -auto-approve

echo "Infrastructure destruction completed!" 