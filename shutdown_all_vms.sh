#!/bin/bash
# Script to gracefully shut down all Azure VMs before infrastructure destruction

echo "WARNING: This script will shut down ALL VMs in your Azure subscription."
read -p "Are you sure you want to continue? (yes/no): " confirmation

if [[ $confirmation != "yes" ]]; then
  echo "Operation canceled."
  exit 0
fi

echo "Logging into Azure..."
az login

echo "Fetching all VMs from your subscription..."
VM_LIST=$(az vm list --query "[].{name:name, resourceGroup:resourceGroup}" -o tsv)

if [ -z "$VM_LIST" ]; then
  echo "No VMs found in your subscription."
  exit 0
fi

echo "Starting shutdown of all VMs..."
echo "$VM_LIST" | while read -r VM_NAME VM_RG; do
  echo "Shutting down VM: $VM_NAME in resource group: $VM_RG"
  az vm deallocate --name "$VM_NAME" --resource-group "$VM_RG" --no-wait
  echo "Shutdown initiated for $VM_NAME"
done

echo "Waiting for all VMs to be shut down (this might take a few minutes)..."
echo "$VM_LIST" | while read -r VM_NAME VM_RG; do
  echo "Waiting for VM $VM_NAME to shut down..."
  az vm wait --name "$VM_NAME" --resource-group "$VM_RG" --custom "powerState!='VM running'" --interval 10 --timeout 300
  VM_STATE=$(az vm get-instance-view --name "$VM_NAME" --resource-group "$VM_RG" --query "instanceView.statuses[1].displayStatus" -o tsv)
  echo "VM $VM_NAME state: $VM_STATE"
done

echo "All VMs have been shut down successfully."
echo "You can now proceed with destroying the infrastructure using: ./destroy_infrastructure.sh" 