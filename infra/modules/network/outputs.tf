output "subnet_id" {
  value = azurerm_subnet.aks.id
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}