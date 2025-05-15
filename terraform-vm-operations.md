# Terraform Azure VM Operations

This document explains how to use Terraform for managing and destroying Azure infrastructure.

## Module Overview

The VM operations module provides infrastructure management capabilities for:

1. Shutting down VMs in a resource group
2. Destroying specified resource groups

## Pure Terraform Workflow

### Infrastructure Destruction

To destroy specific Azure resource groups, use the Terraform variables in your `terraform.tfvars` file:

```hcl
# Set to true to destroy all resource groups listed below
destroy_infrastructure = true

# List of resource groups to destroy
target_resource_group_names = [
  "vpswest_resource_group",
  "newvps_resource_group",
  "vpngermany_resource_group",
  "xuigermany-rg",
  "vpn_service-rg",
  "THE_LATEST_RESOURCE_GROUP"
]
```

Then run the standard Terraform apply command:

```bash
terraform apply
```

### Shutting Down VMs

To shut down all VMs in your subscription:

```hcl
# Set to true to deallocate all VMs
deallocate_vms = true
```

Then run:

```bash
terraform apply
```

## Command Line Override

You can also override these settings from the command line without modifying your tfvars file:

### To Destroy Infrastructure:

```bash
terraform apply -var="destroy_infrastructure=true"
```

### To Shut Down VMs:

```bash
terraform apply -var="deallocate_vms=true"
```

## Important Notes

- Resource group deletion occurs asynchronously in Azure
- Monitor the Azure portal to confirm resources are fully deleted
- The module uses Azure CLI commands via Terraform's local-exec provisioners
- Ensure you're logged into the correct Azure account before running Terraform commands
- This approach integrates infrastructure management directly into your Terraform workflow
- No external scripts are required - everything is managed within Terraform 