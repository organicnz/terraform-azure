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
  
  # Resource Group destruction parameters
  destroy_resource_groups = var.destroy_infrastructure
  target_resource_groups = var.target_resource_group_names
}

# Use the Azure Cleanup module for resource discovery and selective cleanup
module "azure_cleanup" {
  source = "./modules/azure-cleanup"

  # Control which phase of the cleanup process to run
  scan_resources = var.scan_azure_resources
  plan_cleanup = var.plan_azure_cleanup
  execute_cleanup = var.execute_azure_cleanup
  
  # Set to true to confirm each deletion step
  confirm_each_deletion = var.confirm_each_deletion
  
  # Resource groups to exclude from deletion
  exclude_resource_groups = [
    "NetworkWatcherRG",
    "cloud-shell-storage-westeurope",
    "AzureBackupRG_polandcentral_1"
  ]
} 