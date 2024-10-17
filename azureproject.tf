# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}-rg"
  location = var.location

  tags = {
    environment = "production"
    project     = var.resource_prefix
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "production"
    project     = var.resource_prefix
  }
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.resource_prefix}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = var.resource_prefix

  tags = {
    environment = "production"
    project     = var.resource_prefix
  }
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.resource_prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.resource_prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = {
    environment = "production"
    project     = var.resource_prefix
  }
}

# Create a network security group
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.resource_prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
    project     = var.resource_prefix
  }
}

# Associate the NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.instance_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  os_disk {
    name                 = "${var.resource_prefix}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  computer_name  = var.instance_name
  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.key_data
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt full-upgrade -y",
      "sudo apt autoremove -y",
      "sudo reboot"
    ]

    connection {
      type        = "ssh"
      user        = var.admin_username
      host        = azurerm_public_ip.public_ip.ip_address
      private_key = file("~/.ssh/azure_id_rsa.pem")  # Ensure this key is not passphrase protected
    }
  }

  tags = {
    environment = "production"
    project     = var.resource_prefix
  }
}

# Output the public IP address
output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

# Output the VM name
output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

# Output the resource group name
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}