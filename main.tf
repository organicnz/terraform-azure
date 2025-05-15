# Main Terraform Configuration

# Use the VM operations module
module "vm_operations" {
  source = "./modules/vm-operations"
  
  deallocate_vms = var.deallocate_vms
} 