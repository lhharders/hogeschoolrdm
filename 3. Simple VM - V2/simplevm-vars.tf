provider "azurerm" {
  features {}
}

# Create a Random Number between 1000-9999
resource "random_integer" "random" {
  min = 1000
  max = 9999
}

# Create a Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.environment}-RG-VM-${random_integer.random.result}"
  location = var.location

  tags = {
    Environment = var.environment
  }
}

# Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-vm-network-${random_integer.random.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = var.environment
  }
}

# Create a Subnet for the Virtual Network
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a Network Interface for the VM, connected to the Virtual Network
resource "azurerm_network_interface" "main" {
  name                = "${var.environment}-vm-nic-${random_integer.random.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = var.environment
  }
}

# Create the VM, using the Network Interface created above
resource "azurerm_windows_virtual_machine" "main" {
  name                = "${var.environment}-VM-${random_integer.random.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  size           = var.vm_size
  admin_username = var.vm_username
  admin_password = var.vm_password

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = {
    Environment = var.environment
  }
}
