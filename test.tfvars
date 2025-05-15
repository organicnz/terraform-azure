# Test configuration to scan Azure resources
# This will not make any destructive changes

# Azure project configuration
instance_name = "azure-test-instance"
key_data      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTvxxP8J7NBdQySsY8LJsNnb/ZOJ0quI/CJCqLCdM6RbLs8qGYIlOHC/w3mbU2FFRjoYdvs0EPHVtMxgCWw7xYfPnlRBEQsRYFt8nXGIMuDbanZ2iRTfV1vpZ3bOVFZ+ZC/H6KTHN1kg0n/ELiRBzYgQYZUxQm5mKXGHfV+AHqYi16jL/1SSuJdnmVX+yhJrL0gSxUNE7YJO0hmm42hXKjzw4XEVJeJW7vcAtE0lpGiNlnwXWuPkuvEQwc8tk5XyxmXiZFpFWJZPPWQyuB5VYRjbMl9qNQNIJ48aEp+dots15DUQYZrBVlB0ctbTCz2qMRoQxvY5hoji/jjGJWULcl"

# Azure location
location = "polandcentral"

# Azure resource group prefix
resource_group_name_prefix = "azure-test"

# Azure resource_prefix
resource_prefix = "azure-test"

# Azure environment
environment = "development"

# Azure project name
project_name = "azure-test-project"

# VM specs 
vm_size        = "Standard_B1s"
disk_size_gb   = 50
admin_username = "adminuser"

# Infrastructure Operations
deallocate_vms         = false
prepare_destroy        = false
destroy_infrastructure = false

# Azure Cleanup Module Settings
scan_azure_resources  = true
plan_azure_cleanup    = true
execute_azure_cleanup = true
confirm_each_deletion = false
exclude_resource_groups = [
  "NetworkWatcherRG",
  "cloud-shell-storage-*",
  "AzureBackupRG_*",
  "DefaultResourceGroup-*"
]

# VM Configuration Settings
vm_image_publisher = "Canonical"
vm_image_offer     = "0001-com-ubuntu-server-jammy"
vm_image_sku       = "22_04-lts-gen2"
vm_image_version   = "latest"

# Azure Resource Settings
resource_group_name = "web-resource-group"