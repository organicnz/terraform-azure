# Main Terraform Configuration

# Use the VM operations module
module "vm_operations" {
  source = "./modules/vm-operations"
  
  # Original parameters
  deallocate_vms  = var.deallocate_vms
  prepare_destroy = var.prepare_destroy
  
  # Infrastructure destruction parameters
  shutdown_vms = var.destroy_infrastructure
  resource_group_name = var.resource_prefix != null ? "${var.resource_prefix}-rg" : ""
  
  destroy_resource_groups = var.destroy_infrastructure
  target_resource_groups = var.target_resource_group_names
} 