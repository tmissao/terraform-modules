output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = var.storage_account_name
}

output "container_name" {
  value = var.storage_account_container_name
}
