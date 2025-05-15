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