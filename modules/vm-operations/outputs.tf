# VM Operations Module - Outputs

output "deallocate_completed" {
  value = var.deallocate_vms ? "VMs deallocated" : "No action taken"
}

output "deallocate_timestamp" {
  value = var.deallocate_vms ? timestamp() : "N/A"
} 