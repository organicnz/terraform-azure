#!/bin/bash
# Comprehensive Azure Resource Cleanup Script

# Exit on error
set -e

echo "Starting comprehensive Azure resource cleanup..."

# Target resource groups for cleanup
TARGET_RESOURCE_GROUPS=(
  "foodshare-resource-group"
  "FOODSHARE-RESOURCE-GROUP"
  "web-resource-group"
  "WEB-RESOURCE-GROUP"
  "monitoring-resource-group-west-us"
  "monitoring_resource_group"
  "monitoring_resource_group-westus"
  "ResourceMoverRG-uksouth-westus-eus2"
  "azureapp-auto-alerts-432dd4-tamerlanium_gmail_com"
  "azureapp-auto-alerts-a866fe-tamerlanium_gmail_com"
  "DefaultResourceGroup-EUS"
  "vpsgermany-rg"
  "azure-rg"
  "vpswest-resource-group"
  "newvps-resource-group"
  "vpngermany-resource-group"
  "THE_LATEST_RESOURCE_GROUP"
  "xuigermany-rg"
  "vpn_service-rg"
)

# Resource groups to exclude from cleanup
EXCLUDE_RESOURCE_GROUPS=(
  "cloud-shell-storage-westeurope"
  "NetworkWatcherRG"
  "AzureBackupRG_polandcentral_1"
)

# Log file
LOG_FILE="azure_cleanup_$(date +%Y%m%d_%H%M%S).log"

# Function to log messages
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Step 1: Remove all resource locks
log "Step 1: Removing resource locks..."
LOCKS=$(az lock list --output tsv --query "[].id" 2>/dev/null) || true
if [ -n "$LOCKS" ]; then
  log "Found locks, removing..."
  for LOCK_ID in $LOCKS; do
    log "Removing lock: $LOCK_ID"
    az lock delete --ids "$LOCK_ID" || log "Failed to remove lock: $LOCK_ID"
  done
else
  log "No locks found."
fi

# Step 2: Handle Recovery Services vaults
log "Step 2: Cleaning up Recovery Services vaults..."
for RG in "${TARGET_RESOURCE_GROUPS[@]}"; do
  log "Checking for Recovery Services vaults in resource group: $RG"
  
  # Get list of Recovery Services vaults in the resource group
  VAULTS=$(az resource list --resource-group "$RG" --resource-type Microsoft.RecoveryServices/vaults --query "[].name" -o tsv 2>/dev/null) || true
  
  if [ -n "$VAULTS" ]; then
    for VAULT in $VAULTS; do
      log "Found Recovery Services vault: $VAULT in resource group: $RG"
      
      # Disable soft delete to allow for complete deletion
      log "Disabling soft delete for vault: $VAULT"
      az backup vault backup-properties set --resource-group "$RG" --name "$VAULT" --soft-delete-feature-state Disable || log "Failed to disable soft delete for vault: $VAULT"
      
      # Get all protected VMs
      CONTAINERS=$(az backup container list --resource-group "$RG" --vault-name "$VAULT" --backup-management-type AzureIaasVM --output tsv --query "[].name" 2>/dev/null) || true
      
      if [ -n "$CONTAINERS" ]; then
        for CONTAINER in $CONTAINERS; do
          log "Processing container: $CONTAINER"
          
          # List backup items in the container
          ITEMS=$(az backup item list --resource-group "$RG" --vault-name "$VAULT" --backup-management-type AzureIaasVM --output tsv --query "[].name" 2>/dev/null) || true
          
          for ITEM in $ITEMS; do
            log "Disabling protection for item: $ITEM"
            az backup protection disable --resource-group "$RG" --vault-name "$VAULT" --container-name "$CONTAINER" --item-name "$ITEM" --backup-management-type AzureIaasVM --delete-backup-data true --yes || log "Failed to disable protection for item: $ITEM"
            # Wait for operation to complete
            sleep 30
          done
        done
      fi
      
      # Try to delete the vault after clearing protected items
      log "Attempting to delete vault: $VAULT"
      az resource delete --resource-group "$RG" --resource-type Microsoft.RecoveryServices/vaults --name "$VAULT" || log "Failed to delete vault: $VAULT"
    done
  fi
done

# Step 3: Force stop and deallocation of VMs
log "Step 3: Stopping all VMs..."
for RG in "${TARGET_RESOURCE_GROUPS[@]}"; do
  # List VMs in the resource group
  VMS=$(az vm list --resource-group "$RG" --query "[].name" -o tsv 2>/dev/null) || true
  
  if [ -n "$VMS" ]; then
    log "Found VMs in resource group: $RG"
    for VM in $VMS; do
      log "Stopping and deallocating VM: $VM in resource group: $RG"
      az vm deallocate --resource-group "$RG" --name "$VM" --no-wait || log "Failed to deallocate VM: $VM"
    done
  fi
done

# Wait for VM deallocation to complete
log "Waiting for VM deallocations to complete..."
sleep 60

# Step 4: Delete resource groups
log "Step 4: Deleting resource groups..."
for RG in "${TARGET_RESOURCE_GROUPS[@]}"; do
  # Check if resource group exists before attempting to delete
  RG_EXISTS=$(az group exists --name "$RG") || true
  
  if [ "$RG_EXISTS" = "true" ]; then
    log "Deleting resource group: $RG"
    az group delete --name "$RG" --yes --no-wait || log "Failed to delete resource group: $RG"
  else
    log "Resource group not found: $RG"
  fi
done

# Step 5: Wait for deletions to complete and verify
log "Step 5: Waiting for resource group deletions to complete..."
MAX_RETRIES=20
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  PENDING_DELETES=$(az group list --query "[?provisioningState=='Deleting'].name" -o tsv | wc -l | tr -d ' ')
  
  if [ "$PENDING_DELETES" -eq "0" ]; then
    log "All resource group deletions completed!"
    break
  else
    log "$PENDING_DELETES resource groups still being deleted. Waiting 30 seconds..."
    sleep 30
    RETRY_COUNT=$((RETRY_COUNT + 1))
  fi
done

# Step 6: Verify remaining resource groups
log "Step 6: Verifying remaining resource groups..."
REMAINING_GROUPS=$(az group list --query "[].{Name:name, Status:properties.provisioningState}" -o table)
log "Remaining resource groups:"
echo "$REMAINING_GROUPS" | tee -a "$LOG_FILE"

# Step 7: Final verification
log "Step 7: Final verification of resource cleanup..."
RESOURCES=$(az resource list --query "[?!contains(resourceGroup, 'NetworkWatcher') && !contains(resourceGroup, 'cloud-shell-storage')]" -o table)
log "Remaining resources (excluding NetworkWatcher and cloud-shell-storage):"
echo "$RESOURCES" | tee -a "$LOG_FILE"

log "Cleanup process completed. Check the log file for details: $LOG_FILE" 