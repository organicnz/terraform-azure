# Azure Resource Cleanup Module
# This module discovers, plans, and selectively deletes Azure resources

# Resource to scan all Azure resources
resource "null_resource" "resource_discovery" {
  count = var.scan_resources ? 1 : 0

  triggers = {
    scan_trigger = var.scan_resources ? timestamp() : ""
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Scanning Azure resources..."
      mkdir -p ./.azure-cleanup
      
      # Get all resource groups
      echo "Discovering resource groups..."
      az group list --query "[].{Name:name, Location:location, Status:properties.provisioningState}" -o json > ./.azure-cleanup/resource_groups.json
      
      # Get all resources
      echo "Discovering all resources..."
      az resource list --query "[].{Name:name, ResourceGroup:resourceGroup, Type:type, Location:location}" -o json > ./.azure-cleanup/resources.json
      
      # Get all VMs
      echo "Discovering virtual machines..."
      az vm list --query "[].{Name:name, ResourceGroup:resourceGroup, Location:location, PowerState:powerState}" -o json > ./.azure-cleanup/vms.json
      
      # Get all recovery services vaults
      echo "Discovering recovery services vaults..."
      az resource list --resource-type Microsoft.RecoveryServices/vaults --query "[].{Name:name, ResourceGroup:resourceGroup, Location:location}" -o json > ./.azure-cleanup/vaults.json
      
      # Get all resource locks
      echo "Discovering resource locks..."
      az lock list --query "[].{Name:name, ResourceGroup:resourceGroup, Level:level, Notes:notes}" -o json > ./.azure-cleanup/locks.json
      
      echo "Resource discovery completed. Results stored in ./.azure-cleanup/"
      echo "To review discovered resources, examine the JSON files in ./.azure-cleanup/"
    EOT
  }
}

# Resource to generate cleanup plan
resource "null_resource" "generate_cleanup_plan" {
  count = var.plan_cleanup ? 1 : 0
  
  # Ensure discovery runs first
  depends_on = [null_resource.resource_discovery]

  triggers = {
    plan_trigger = var.plan_cleanup ? timestamp() : ""
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Generating cleanup plan..."
      mkdir -p ./.azure-cleanup
      
      # Create plan file
      echo "# Azure Resources Cleanup Plan" > ./.azure-cleanup/cleanup_plan.md
      echo "Generated at: $(date)" >> ./.azure-cleanup/cleanup_plan.md
      echo "" >> ./.azure-cleanup/cleanup_plan.md
      
      # Add excluded resource groups
      echo "## Excluded Resource Groups" >> ./.azure-cleanup/cleanup_plan.md
      echo "The following resource groups will NOT be deleted:" >> ./.azure-cleanup/cleanup_plan.md
      echo "" >> ./.azure-cleanup/cleanup_plan.md
      
      for RG in ${join(" ", var.exclude_resource_groups)}; do
        echo "- $RG" >> ./.azure-cleanup/cleanup_plan.md
      done
      echo "" >> ./.azure-cleanup/cleanup_plan.md
      
      # Generate list of resource groups to delete
      echo "## Resource Groups to Delete" >> ./.azure-cleanup/cleanup_plan.md
      echo "The following resource groups will be deleted:" >> ./.azure-cleanup/cleanup_plan.md
      echo "" >> ./.azure-cleanup/cleanup_plan.md
      
      # Parse the JSON for resource groups and exclude the ones in var.exclude_resource_groups
      # Store target groups in a file for the execution phase
      rm -f ./.azure-cleanup/target_resource_groups.txt
      touch ./.azure-cleanup/target_resource_groups.txt
      
      cat ./.azure-cleanup/resource_groups.json | jq -r '.[] | .Name' | while read RG; do
        IS_EXCLUDED=false
        for EXCLUDED in ${join(" ", var.exclude_resource_groups)}; do
          if [ "$RG" == "$EXCLUDED" ]; then
            IS_EXCLUDED=true
            break
          fi
        done
        
        if [ "$IS_EXCLUDED" == "false" ]; then
          echo "- $RG" >> ./.azure-cleanup/cleanup_plan.md
          echo "$RG" >> ./.azure-cleanup/target_resource_groups.txt
        fi
      done
      echo "" >> ./.azure-cleanup/cleanup_plan.md
      
      # Add special resources section
      echo "## Special Resources Requiring Additional Handling" >> ./.azure-cleanup/cleanup_plan.md
      echo "The following resources require special handling during deletion:" >> ./.azure-cleanup/cleanup_plan.md
      echo "" >> ./.azure-cleanup/cleanup_plan.md
      
      # Recovery Services Vaults
      echo "### Recovery Services Vaults" >> ./.azure-cleanup/cleanup_plan.md
      if [ -s ./.azure-cleanup/vaults.json ] && [ "$(cat ./.azure-cleanup/vaults.json)" != "[]" ]; then
        cat ./.azure-cleanup/vaults.json | jq -r '.[] | "- " + .Name + " (Resource Group: " + .ResourceGroup + ")"' >> ./.azure-cleanup/cleanup_plan.md
      else
        echo "- None found" >> ./.azure-cleanup/cleanup_plan.md
      fi
      echo "" >> ./.azure-cleanup/cleanup_plan.md
      
      # Resource Locks
      echo "### Resource Locks" >> ./.azure-cleanup/cleanup_plan.md
      if [ -s ./.azure-cleanup/locks.json ] && [ "$(cat ./.azure-cleanup/locks.json)" != "[]" ]; then
        cat ./.azure-cleanup/locks.json | jq -r '.[] | "- " + .Name + " (Resource Group: " + (.ResourceGroup // "unknown") + ", Level: " + .Level + ")"' >> ./.azure-cleanup/cleanup_plan.md
      else
        echo "- None found" >> ./.azure-cleanup/cleanup_plan.md
      fi
      echo "" >> ./.azure-cleanup/cleanup_plan.md
      
      # Generate cleanup script
      echo "Generating cleanup script..."
      cp ${path.module}/scripts/cleanup_template.sh ./.azure-cleanup/execute_cleanup.sh
      chmod +x ./.azure-cleanup/execute_cleanup.sh
      
      echo "Cleanup plan generated."
      echo "To review the cleanup plan, see ./.azure-cleanup/cleanup_plan.md"
      echo "To execute the cleanup plan, run: ./.azure-cleanup/execute_cleanup.sh"
    EOT
  }
}

# Resource to execute cleanup
resource "null_resource" "execute_cleanup" {
  count = var.execute_cleanup ? 1 : 0
  
  # Ensure plan is generated first
  depends_on = [null_resource.generate_cleanup_plan]

  triggers = {
    execute_trigger = var.execute_cleanup ? timestamp() : ""
  }

  provisioner "local-exec" {
    command = <<-EOT
      if [ -f "./.azure-cleanup/execute_cleanup.sh" ]; then
        echo "Executing cleanup plan..."
        ./.azure-cleanup/execute_cleanup.sh ${var.confirm_each_deletion ? "--confirm" : "--auto"}
      else
        echo "Error: Cleanup script not found. Please run the plan step first."
        exit 1
      fi
    EOT
  }
}

# Local file to store module documentation
resource "local_file" "azure_cleanup_readme" {
  count = var.scan_resources ? 1 : 0
  
  filename = "./.azure-cleanup/README.md"
  content = <<-EOT
# Azure Resource Cleanup Module

This module helps you discover, plan, and selectively clean up Azure resources.

## Usage

The cleanup process is divided into three phases:

1. **Discovery Phase**: Scans your Azure subscription for all resources
2. **Planning Phase**: Creates a cleanup plan based on discovered resources
3. **Execution Phase**: Executes the cleanup plan with optional confirmation steps

## Files Created

- `resource_groups.json`: List of all resource groups
- `resources.json`: List of all resources
- `vms.json`: List of all virtual machines
- `vaults.json`: List of all recovery services vaults
- `locks.json`: List of all resource locks
- `cleanup_plan.md`: The cleanup plan in Markdown format
- `execute_cleanup.sh`: Script to execute the cleanup plan

## Manual Execution

You can run the cleanup script manually with:

```
./.azure-cleanup/execute_cleanup.sh --confirm
```

Use `--auto` instead of `--confirm` to skip confirmation prompts.

## Excluded Resource Groups

The following resource groups are excluded from deletion:

${join("\n", formatlist("- %s", var.exclude_resource_groups))}

## Terraform Variables

- `scan_resources`: Set to true to scan resources (discovery phase)
- `plan_cleanup`: Set to true to generate a cleanup plan (planning phase)
- `execute_cleanup`: Set to true to execute the cleanup plan (execution phase)
- `confirm_each_deletion`: Set to true to confirm each deletion step
- `exclude_resource_groups`: List of resource groups to exclude from deletion

EOT
} 