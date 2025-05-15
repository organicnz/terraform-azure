#!/bin/bash
# Script to import existing Azure resources into Terraform state

# Initialize Terraform
terraform init

# Set script to exit on error
set -e

echo "Importing Azure resources into Terraform state..."

# Resource Groups
echo "Importing Resource Groups..."
# Replace these with the actual resource group names from your account
terraform import azurerm_resource_group.vpsgermany_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpsgermany-rg
terraform import azurerm_resource_group.xuigermany_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/xuigermany-rg
terraform import azurerm_resource_group.vpn_service_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpn_service-rg
terraform import azurerm_resource_group.foodshare_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/foodshare-resource-group
terraform import azurerm_resource_group.web_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/web-resource-group
terraform import azurerm_resource_group.monitoring_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/monitoring-resource-group-west-us
terraform import azurerm_resource_group.vpswest_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpswest_resource_group
terraform import azurerm_resource_group.newvps_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/newvps_resource_group
terraform import azurerm_resource_group.vpngermany_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpngermany_resource_group
terraform import azurerm_resource_group.the_latest_rg /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/THE_LATEST_RESOURCE_GROUP

# Virtual Networks
echo "Importing Virtual Networks..."
terraform import azurerm_virtual_network.vpsgermany_vnet /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpsgermany-rg/providers/Microsoft.Network/virtualNetworks/vpsgermany-vnet
terraform import azurerm_virtual_network.xuigermany_vnet /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/xuigermany-rg/providers/Microsoft.Network/virtualNetworks/xuigermany-vnet
terraform import azurerm_virtual_network.vpn_service_vnet /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpn_service-rg/providers/Microsoft.Network/virtualNetworks/vpn_service-vnet
terraform import azurerm_virtual_network.foodshare_network /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/foodshare-resource-group/providers/Microsoft.Network/virtualNetworks/foodshare-network
terraform import azurerm_virtual_network.web_network /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/web-resource-group/providers/Microsoft.Network/virtualNetworks/web-network

# Public IPs
echo "Importing Public IPs..."
terraform import azurerm_public_ip.vpsgermany_public_ip /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpsgermany-rg/providers/Microsoft.Network/publicIPAddresses/vpsgermany-public-ip
terraform import azurerm_public_ip.xuigermany_public_ip /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/xuigermany-rg/providers/Microsoft.Network/publicIPAddresses/xuigermany-public-ip
terraform import azurerm_public_ip.vpn_service_public_ip /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpn_service-rg/providers/Microsoft.Network/publicIPAddresses/vpn_service-public-ip

# Network Interfaces
echo "Importing Network Interfaces..."
terraform import azurerm_network_interface.vpsgermany_nic /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpsgermany-rg/providers/Microsoft.Network/networkInterfaces/vpsgermany-nic
terraform import azurerm_network_interface.xuigermany_nic /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/xuigermany-rg/providers/Microsoft.Network/networkInterfaces/xuigermany-nic
terraform import azurerm_network_interface.vpn_service_nic /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpn_service-rg/providers/Microsoft.Network/networkInterfaces/vpn_service-nic

# Virtual Machines
echo "Importing Virtual Machines..."
terraform import azurerm_linux_virtual_machine.vpsgermany_vm /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpsgermany-rg/providers/Microsoft.Compute/virtualMachines/vpsgermany
terraform import azurerm_linux_virtual_machine.xuigermany_vm /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/xuigermany-rg/providers/Microsoft.Compute/virtualMachines/xuigermany
terraform import azurerm_linux_virtual_machine.vpn_service_vm /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpn_service-rg/providers/Microsoft.Compute/virtualMachines/vpn_service

# Disks
echo "Importing Disks..."
terraform import azurerm_managed_disk.vpsgermany_osdisk /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/VPSGERMANY-RG/providers/Microsoft.Compute/disks/vpsgermany-osdisk
terraform import azurerm_managed_disk.xuigermany_osdisk /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/XUIGERMANY-RG/providers/Microsoft.Compute/disks/xuigermany-osdisk
terraform import azurerm_managed_disk.vpn_service_osdisk /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/VPN_SERVICE-RG/providers/Microsoft.Compute/disks/vpn_service-osdisk

# Bastion Hosts
echo "Importing Bastion Hosts..."
terraform import azurerm_bastion_host.vpngermany_bastion /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpngermany_resource_group/providers/Microsoft.Network/bastionHosts/vpngermany_network-bastion
terraform import azurerm_bastion_host.web_bastion /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/web-resource-group/providers/Microsoft.Network/bastionHosts/web-network-bastion
terraform import azurerm_bastion_host.foodshare_bastion /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/foodshare-resource-group/providers/Microsoft.Network/bastionHosts/foodshare-network-bastion

echo "Import completed successfully!" 