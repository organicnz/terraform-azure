# Managing VM Operations with Terraform

Instead of using separate shell scripts, we can leverage Terraform's flexibility to manage the lifecycle of Azure resources, including shutting down VMs before destroying infrastructure.

## Shutting Down VMs with Terraform

You can use Terraform variables and commands to control the shutdown process:

1. Add this section to your `.tfvars` file when you want to shut down VMs before destroying:

```hcl
# terraform.tfvars
deallocate_vms = true
```

2. Run the Terraform apply command to trigger the VM shutdown:

```bash
terraform apply -var-file="terraform.tfvars"
```

3. After VMs are shut down, proceed with destroying infrastructure:

```bash
terraform destroy
```

## Advanced: Creating a VM Shutdown Module

For a more structured approach, you can create a Terraform module that handles VM shutdowns. Here's how:

1. Create a `modules/vm-operations` directory structure
2. In that directory, define the following files:

**main.tf**:
```hcl
resource "null_resource" "deallocate_vms" {
  count = var.deallocate_vms ? 1 : 0
  
  provisioner "local-exec" {
    command = "az vm deallocate --ids $(az vm list --query '[].id' -o tsv)"
  }
}
```

**variables.tf**:
```hcl
variable "deallocate_vms" {
  description = "Whether to deallocate all VMs"
  type        = bool
  default     = false
}
```

**outputs.tf**:
```hcl
output "deallocate_completed" {
  value = var.deallocate_vms ? "VMs deallocated" : "No action taken"
}
```

3. Use the module in your main configuration:

```hcl
module "vm_operations" {
  source = "./modules/vm-operations"
  
  deallocate_vms = var.deallocate_vms
}
```

## Complete Terraform Workflow

For a complete workflow to manage your infrastructure:

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **List all resources** that will be modified:
   ```bash
   terraform plan
   ```

3. **Shut down VMs**:
   ```bash
   terraform apply -var="deallocate_vms=true" -target=module.vm_operations
   ```

4. **Destroy infrastructure**:
   ```bash
   terraform destroy
   ```

This approach keeps everything within Terraform, making it more maintainable and integrated with your infrastructure as code. 