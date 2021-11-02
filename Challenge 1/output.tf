# Outputs

# Show output for Resource Group Name
output "Resource_Group_Name" {
    description = "Name of Resource Group"
    value = azurerm_resource_group.main.name
}