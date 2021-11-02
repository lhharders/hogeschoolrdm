# Variables

# Environment type, like 'test' or 'production'
variable "environment" {
    type = string
    description = "Name of the environment"
    #default = "test"
}

# Location for resources, default is West Europe
variable "location" {
    type = string
    description = "Azure location for resources"
    default = "westEurope"
}

# VM size
variable "vm_size" {
    type = string
    description = "VM Size"
    default = "Standard_DS1_v2"
}

# VM Username
variable "vm_username" {
    type = string
    description = "VM Username"
    default = "adminuser"
}

# VM Password
variable "vm_password" {
    type = string
    description = "VM Password"
    default = "P@$$w0rd1234!"
}