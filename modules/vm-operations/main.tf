# VM Operations Module - Main Configuration

# Resource to stop/deallocate all VMs
resource "null_resource" "deallocate_vms" {
  count = var.deallocate_vms ? 1 : 0
  
  triggers = {
    # This ensures this resource is recreated when we want to deallocate VMs
    deallocate_trigger = var.deallocate_vms ? timestamp() : ""
  }

  provisioner "local-exec" {
    # Command to deallocate all VMs using Azure CLI
    command = <<-EOT
      echo "Starting shutdown of all Azure VMs..."
      
      # Get all VM IDs
      VM_IDS=$(az vm list --query "[].id" -o tsv)
      
      if [ -z "$VM_IDS" ]; then
        echo "No VMs found in your subscription."
        exit 0
      fi
      
      # Deallocate all VMs
      echo "Deallocating all VMs..."
      az vm deallocate --ids $VM_IDS
      
      echo "All VMs have been shut down successfully."
    EOT
  }
}

# Resource to prepare for infrastructure destruction
resource "null_resource" "prepare_destroy" {
  count = var.prepare_destroy ? 1 : 0
  
  triggers = {
    # This ensures this resource is recreated when we want to prepare for destruction
    prepare_destroy_trigger = var.prepare_destroy ? timestamp() : ""
  }

  provisioner "local-exec" {
    # Command to prepare for destruction
    command = <<-EOT
      echo "Preparing for infrastructure destruction..."
      
      # Show all resources that will be destroyed
      echo "The following resources will be affected:"
      az resource list --output table
      
      echo "Preparation complete. You can now run: terraform destroy"
    EOT
  }
}

# VM Operations Module
# This module provides operations for managing Azure VMs including shutdown and destruction

# Shutdown all VMs in a resource group
resource "null_resource" "shutdown_vms" {
  count = var.shutdown_vms ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      az vm deallocate --ids $(az vm list -g ${var.resource_group_name} --query "[].id" -o tsv) --no-wait
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Destroy specific resource groups
resource "null_resource" "destroy_resource_groups" {
  count = var.destroy_resource_groups ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      for rg in ${join(" ", var.target_resource_groups)}; do
        echo "Destroying resource group: $rg"
        az group delete --name $rg --yes --no-wait
      done
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
} 