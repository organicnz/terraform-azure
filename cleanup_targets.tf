# Resource Group Cleanup Configuration
# This file defines the resource groups that are targeted for cleanup

locals {
  # List of resource groups that are targets for deletion
  target_resource_groups = [
    # Add resource groups you want to target for deletion here
    # Example: "resource-group-name"
  ]

  # Resource groups to exclude from deletion (critical infrastructure)
  exclude_resource_groups = [
    "cloud-shell-storage-westeurope",
    "NetworkWatcherRG",
    "monitoring-resource-group-west-us",
    "monitoring_resource_group-westus",
    "monitoring_resource_group",
    "azure-rg",
    "foodshare-resource-group",
    "web-resource-group",
    "AzureBackupRG_polandcentral_1"
  ]
}

# The Terraform destroy operation for resource groups
# Activate this only when you need to delete resources
# by setting destroy_infrastructure = true in terraform.tfvars
resource "null_resource" "destroy_resource_groups" {
  count = var.destroy_infrastructure ? length(local.target_resource_groups) : 0

  # This ensures the resource is always recreated when activated
  triggers = {
    resource_group_name = local.target_resource_groups[count.index]
    timestamp = timestamp()
  }

  # Azure CLI command to delete the resource group
  provisioner "local-exec" {
    command = <<-EOT
      echo "Destroying resource group: ${local.target_resource_groups[count.index]}"
      az group delete --name "${local.target_resource_groups[count.index]}" --yes
    EOT
  }
} 