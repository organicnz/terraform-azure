## Azure creds
instance_name = "vpn_service"
key_data      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCb7T6hz3sH+wynfqhiTo8D3FzW0UR+aBpQna8u72b/vX4T0PV6Aii0/r4YlNGCf+l8wECs1kn2Z+OxsBHL2t5RS8H5l6YXNPDg5ciurwp4JlKbstxA90DMF8JKG7pbiNYpoqbIOP944rWzHeUNYTREdqWy8ghjPb7AKh+cDQPRGrgRUkoAg/Oy3fOI45WkT5hHoUARLEDEcYWto3ImSgts7OaJm8FmkZWKnoxGp5SqKeiIdvOGDEvJEJzK+fmRFYaytbNDesYZaVGhcnc30xl33OzyCp4OU738mKCea0KY0Vcos/tJjG+I8yT6n3KQl4KyETGY3T8wmmYJfejBJioMOqaCRuG6X4Rn5/SMdQ7fOECkvRzMrb8BbxzJYLUHKWb+Vk8WW5AWorbXdyrvV5yYTySthhhsuaj12fLp+SFTqbP8A5+xe2ijAcrgWi8VLhrx7aU/Wq2XTNJEm4lOq3W9OEIL5ncqfcYZOlb2MQa3c7axBcDF3JWs+irmk3ymi1E="
# key_data = "{{ lookup('file', lookup('env','HOME') + '/.ssh/azure_id_rsa.pub') }}"
# azure_token = "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCIsImtpZCI6IjFrYnhacFJNQGJSI0tSbE1xS1lqIn0.eyJ1c2VyIjoiY2E1NjY3NiIsInR5cGUiOiJhcGlfa2V5IiwicG9ydGFsX3Rva2VuIjoiNjM5MDFlY2ItZGY0MC00Mjk4LWEwOWMtNDQ5NGM2NmYzYzU0IiwiYXBpX2tleV9pZCI6ImY4NjdiNDMzLTVlZGEtNDg1Yi04Y2ZiLTEwNWRlM2Y0M2EzOSIsImlhdCI6MTY4ODAyMzQ2Mn0.J1xfUNHmjbuLCIi2yvb8K-932cGsR673AP5-UdBiH9GkC_sJ3N_T3oi0bs4s8YWZBCN5xFVS8swJJqOa4Maoi8VI52VSnQZTbb38wLEMqgVmypdFEhLv--jN0hZw5A8im7n1P4E06zFla-YjDN-rceZ1FNZ7fgXJsf6oPDIda1n5KBo7zDwfd0qeeLMbG1Po5elVdNFbzkMsIz7BquRz_b4iLGbylQcOecXC_CQ7yVWC3ZBTTjfzgbZOHSp9s34Q_lAtYln9UQOIPyisFMguizxDrSmiHby19MzjOB-j5IR8-IiMyB3mLi_3soyzkWf04RLVpywWEa89Tv7b6v92HPqvCRVAGwwj0JoM3gxIXIj7RAG2amwF4GxJT86y_hEsI_7YdXRMMzQ_OTAbGnZHv2tTo8uoD56yg1VWY6y2ZeC-H5x0TgcpwQ1rhR25dsGsSLylB1QqJXg5--XR9GnZ1_5-l59ecMY73n6LTG1-8cJ2a9GdGduxIrG-bf6M_hKN"

// To create secrets use "az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>""
// With a name "az ad sp create-for-rbac --name "vpn_service_terraform_app" --role="Contributor" --scopes="/subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc""
subscription_id      = "f8368c46-055d-4b25-b4d4-7410f92cb8bc"  # This is from your previous configuration
client_id            = "39c3c0f7-f790-4066-b75a-33db729ce82d"  # This is the "appId"
client_secret        = "BjY8Q~Z_3JCqku2hhYwqZ6o14zYW5EGGUPSx_aiR"  # This is the "password"
tenant_id            = "f107b5bb-3869-4b6e-844e-d9cc0dcb36a0"  # This is the "tenant"


# Azure location
location = "Germany West Central"

# Azure resource group prefix
resource_group_name_prefix = "vpn_service"

# Azure resource_prefix
resource_prefix = "vpn_service"

# Azure environment
environment = "production"  # or "development", "staging", etc.

# Azure project name
project_name = "vpn_service"  # or whatever name you want to give your project

# azurerm_resource_group = "$instance_name"+"_resource_group"
# azurerm_resource_group = "${var.instance_name}_resource_group"

# azurerm_resource_group = instance_name + "-resource-group"
# azurerm_resource_group = local.instance_name_resource_group
# azurerm_resource_group = "vpn_service-resource-group"

# location               = "UK South" // To change the location to "UK South", "Poland Central" or "Germany West Central"

# Networking
# network           = "${var.instance_name}-network"
# subnet            = "${var.instance_name}-subnet"
# public_ip         = "${var.instance_name}-public-ip"
# network_interface = "${var.instance_name}-network-interface"
# ip_configuration  = "${var.instance_name}-ip-configuration"

# network           = local.instance_name_network
# subnet            = local.instance_name_subnet
# public_ip         = local.instance_name_public_ip
# network_interface = local.instance_name_network_interface
# ip_configuration  = local.instance_name_ip_configuration

# VM specs 
# virtual_machine   = "${var.instance_name}-virtual-machine"
vm_size = "Standard_D8ds_v4"
# storage_os_disk   = "${var.instance_name}-os-disk"
disk_size_gb = 1000 # Update the disk size to 1000GB

# virtual_machine   = local.instance_name_virtual_machine
# vm_size           = "Standard_DS3_v2"
# storage_os_disk   = local.instance_name_os_disk
# disk_size_gb      = 100

# User
admin_username = "organic"

# variable "resource_group_name" {
#   type        = string
#   description = "value of resource group name"
# }
# variable "resource_group_location" {
#   type        = string
#   description = "value of resource group location"
# }
# variable "environment" {
#   type        = string
#   description = "value of environment"
# }