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

- NetworkWatcherRG
- cloud-shell-storage-westeurope
- AzureBackupRG_polandcentral_1

## Terraform Variables

- `scan_resources`: Set to true to scan resources (discovery phase)
- `plan_cleanup`: Set to true to generate a cleanup plan (planning phase)
- `execute_cleanup`: Set to true to execute the cleanup plan (execution phase)
- `confirm_each_deletion`: Set to true to confirm each deletion step
- `exclude_resource_groups`: List of resource groups to exclude from deletion

