#!/bin/bash
# Azure Resource Cleanup Script
# Generated by Terraform Azure Cleanup Module

# Create logs directory
mkdir -p ./logs

# Log file
LOG_FILE="./logs/azure_cleanup_$(date +%Y%m%d_%H%M%S).log"

# Color codes for readability
GREEN='[0;32m'
YELLOW='[1;33m'
RED='[0;31m'
BLUE='[0;34m'
NC='[0m'

# Function to log messages
log() {
  echo -e "${BLUE}$(date '+%Y-%m-%d %H:%M:%S')${NC} - $1" | tee -a "$LOG_FILE"
}

# Parse arguments
AUTO_MODE=false
if [ "$1" == "--auto" ]; then
  AUTO_MODE=true
  log "Running in automatic mode - no confirmation prompts will be shown"
else
  log "Running in interactive mode - confirmation will be required for each action"
fi

# Main cleanup logic
log "Starting Azure resource cleanup..."

# Load target resource groups
if [ -f "./.azure-cleanup/target_resource_groups.txt" ]; then
  TARGET_RGS=$(cat ./.azure-cleanup/target_resource_groups.txt)
else
  log "${RED}Error: Target resource groups file not found. Run discovery and planning first.${NC}"
  exit 1
fi

# 1. Remove resource locks
log "Step 1: Removing resource locks..."

LOCKS=$(az lock list --query "[].id" -o tsv 2>/dev/null) || true
if [ -n "$LOCKS" ]; then
  for LOCK_ID in $LOCKS; do
    if [ "$AUTO_MODE" == "true" ] || (log "Remove lock: $LOCK_ID?" && read -p "Proceed? (y/n): " CONFIRM && [ "$CONFIRM" == "y" ]); then
      az lock delete --ids "$LOCK_ID" && log "${GREEN}Lock deleted: $LOCK_ID${NC}" || log "${RED}Failed to delete lock: $LOCK_ID${NC}"
    else
      log "Skipping lock: $LOCK_ID"
    fi
  done
else
  log "No locks found."
fi

# 2. Clean up Recovery Services vaults
log "Step 2: Cleaning up Recovery Services vaults..."

for RG in $TARGET_RGS; do
  log "Checking for Recovery Services vaults in resource group: $RG"
  VAULTS=$(az resource list --resource-group "$RG" --resource-type Microsoft.RecoveryServices/vaults --query "[].name" -o tsv 2>/dev/null) || true
  
  if [ -n "$VAULTS" ]; then
    for VAULT in $VAULTS; do
      log "${YELLOW}Found Recovery Services vault: $VAULT in resource group: $RG${NC}"
      
      if [ "$AUTO_MODE" == "true" ] || (log "Clean up vault: $VAULT?" && read -p "Proceed? (y/n): " CONFIRM && [ "$CONFIRM" == "y" ]); then
        # Step 1: Disable soft delete
        log "Disabling soft delete for vault: $VAULT"
        az backup vault backup-properties set --resource-group "$RG" --name "$VAULT" --soft-delete-feature-state Disable 2>/dev/null || log "Soft delete disable failed - continuing anyway"
        
        # Step 2: Find and remove all backup items
        CONTAINERS=$(az backup container list --resource-group "$RG" --vault-name "$VAULT" --backup-management-type AzureIaasVM --query "[].name" -o tsv 2>/dev/null) || true
        
        if [ -n "$CONTAINERS" ]; then
          for CONTAINER in $CONTAINERS; do
            log "Processing container: $CONTAINER"
            ITEMS=$(az backup item list --resource-group "$RG" --vault-name "$VAULT" --backup-management-type AzureIaasVM --container-name "$CONTAINER" --query "[].name" -o tsv 2>/dev/null) || true
            
            if [ -n "$ITEMS" ]; then
              for ITEM in $ITEMS; do
                log "Disabling protection for item: $ITEM"
                az backup protection disable --resource-group "$RG" --vault-name "$VAULT" --container-name "$CONTAINER" --item-name "$ITEM" --backup-management-type AzureIaasVM --delete-backup-data true --yes --force 2>/dev/null || log "Failed to disable protection for item: $ITEM"
                
                # Wait for operation to complete
                log "Waiting for protection disable operation to complete..."
                sleep 30
              done
            fi
          done
        fi
        
        # Step 3: Delete vault
        log "Attempting to delete vault: $VAULT"
        if az resource delete --resource-group "$RG" --resource-type Microsoft.RecoveryServices/vaults --name "$VAULT" 2>/dev/null; then
          log "${GREEN}Successfully deleted vault: $VAULT${NC}"
        else
          log "${RED}Failed to delete vault: $VAULT${NC}"
        fi
      else
        log "Skipping vault: $VAULT"
      fi
    done
  else
    log "No Recovery Services vaults found in resource group: $RG"
  fi
done

# 3. Delete resource groups
log "Step 3: Deleting resource groups..."

for RG in $TARGET_RGS; do
  log "Processing resource group: $RG"
  
  # Check if RG exists
  if [ "$(az group exists --name "$RG")" == "true" ]; then
    if [ "$AUTO_MODE" == "true" ] || (log "Delete resource group: $RG?" && read -p "Proceed? (y/n): " CONFIRM && [ "$CONFIRM" == "y" ]); then
      log "Deleting resource group: $RG"
      if az group delete --name "$RG" --yes; then
        log "${GREEN}Successfully deleted resource group: $RG${NC}"
      else
        log "${RED}Failed to delete resource group: $RG${NC}"
      fi
    else
      log "Skipping resource group: $RG"
    fi
  else
    log "Resource group $RG does not exist - skipping"
  fi
done

# Cleanup completed
log "${GREEN}Azure resource cleanup completed. Check the log file for details: $LOG_FILE${NC}"
