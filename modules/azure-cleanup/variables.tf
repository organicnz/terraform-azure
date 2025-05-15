# Azure Cleanup Module Variables

variable "scan_resources" {
  description = "Set to true to scan Azure resources (discovery phase)"
  type        = bool
  default     = false
}

variable "plan_cleanup" {
  description = "Set to true to generate a cleanup plan (planning phase)"
  type        = bool
  default     = false
}

variable "execute_cleanup" {
  description = "Set to true to execute the cleanup plan (execution phase)"
  type        = bool
  default     = false
}

variable "confirm_each_deletion" {
  description = "Set to true to confirm each deletion step during execution"
  type        = bool
  default     = true
}

variable "exclude_resource_groups" {
  description = "List of resource groups to exclude from deletion"
  type        = list(string)
  default     = ["NetworkWatcherRG", "cloud-shell-storage-westeurope", "AzureBackupRG_polandcentral_1"]
} 