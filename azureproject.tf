# Create the resource group
resource "null_resource" "create_resource_group" {
  provisioner "local-exec" {
    command = "az group create --name vpngermany-resource-group --location 'Germany West Central' --tags {tags}" //Location Germany West Central or UK South
  }
}

# Create a service principal
resource "null_resource" "create_service_principal" {
  depends_on = [null_resource.create_resource_group]

  provisioner "local-exec" {
    command = "az ad sp create-for-rbac --name vpngermany_terraform_app --role Contributor --scopes /subscriptions/f8368c46-055d-4b25-b4d4-7410f92cb8bc/resourceGroups/vpngermany-resource-group"
  }
}

# Create a resource group
resource "azurerm_resource_group" "vpngermany" {
  name     = var.azurerm_resource_group
  location = var.location

  # Disable destruction for the resource group
  lifecycle {
    prevent_destroy = false
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vpngermany" {
  name                = var.network
  resource_group_name = azurerm_resource_group.vpngermany.name
  location            = azurerm_resource_group.vpngermany.location
  address_space       = ["10.0.0.0/16"]

  # Disable destruction for the virtual network
  lifecycle {
    prevent_destroy = false
  }
}

# Create a subnet
resource "azurerm_subnet" "vpngermany" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.vpngermany.name
  virtual_network_name = azurerm_virtual_network.vpngermany.name
  address_prefixes     = ["10.0.1.0/24"]

  # # Disable destruction for the public IP address
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create a public IP address
resource "azurerm_public_ip" "vpngermany" {
  name                = var.public_ip
  location            = azurerm_resource_group.vpngermany.location
  resource_group_name = azurerm_resource_group.vpngermany.name
  allocation_method   = "Static"

  # # Disable destruction for the public IP address
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create a network interface
resource "azurerm_network_interface" "vpngermany-resource-group" {
  name                = var.network_interface
  location            = azurerm_resource_group.vpngermany.location
  resource_group_name = azurerm_resource_group.vpngermany.name

  ip_configuration {
    name                          = var.ip_configuration
    subnet_id                     = azurerm_subnet.vpngermany.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.4" # Specify the static private IP address
    public_ip_address_id          = azurerm_public_ip.vpngermany.id
  }

  # # Disable destruction for the network interface
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# # Create DNS | Has issues with networking
# resource "azurerm_virtual_network_dns_servers" "vpngermany" {
#   virtual_network_id = azurerm_virtual_network.vpngermany.id
#   dns_servers        = ["10.7.7.2", "10.7.7.7", "10.7.7.1"]
# }

# resource "azurerm_dns_zone" "vpngermany" {
#   name                = "vpngermany-foodshare.uksouth.cloudapp.azure.com"
#   resource_group_name = azurerm_resource_group.vpngermany.name
# }

# resource "azurerm_dns_a_record" "vpngermany" {
#   name                = "vpngermany"
#   zone_name           = azurerm_dns_zone.vpngermany.name
#   resource_group_name = azurerm_resource_group.vpngermany.name
#   ttl                 = 300
#   records             = ["10.0.180.17"]
# }

# Create a virtual machine
resource "azurerm_virtual_machine" "vpngermany" {
  name                  = var.virtual_machine
  location              = azurerm_resource_group.vpngermany.location
  resource_group_name   = azurerm_resource_group.vpngermany.name
  vm_size               = var.vm_size # 4 cores, 16 GB RAM
  network_interface_ids = [azurerm_network_interface.vpngermany-resource-group.id]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = var.storage_os_disk
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = var.disk_size_gb
  }

  os_profile {
    computer_name  = var.instance_name
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/organic/.ssh/authorized_keys"
      key_data = var.key_data # Specify the path to your local public key file
    }
  }

  # Disable destruction for the virtual machine
  lifecycle {
    prevent_destroy = false
  }
}


