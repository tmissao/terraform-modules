terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.63.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "1.5.1"
    }
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "keyvault" {
  name                = var.keyvault.name
  resource_group_name = var.keyvault.resource_group_name
}

data "azuread_group" "allowed_groups_to_access" {
  for_each     = toset(var.storage_account_allowed_groups_to_access_data)
  display_name = each.key
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.tags
}

resource "azurerm_storage_account" "storage" {
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = var.storage_account_tier
  account_kind              = var.storage_account_kind
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
  blob_properties {
    versioning_enabled = var.storage_account_blob_versioning_enabled
    delete_retention_policy {
      days = var.storage_account_blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_account_container_delete_retention_days
    }
  }
  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.storage_account_allowed_ips
    virtual_network_subnet_ids = var.storage_account_allowed_network_subnets_ids
  }
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "storage" {
  key_vault_id = data.azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_storage_account.storage.identity.0.principal_id
  key_permissions    = ["get", "create", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
  secret_permissions = ["get"]
}

resource "azurerm_key_vault_key" "state_key" {
  name         = "${var.storage_account_name}-key"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  depends_on = [
    azurerm_key_vault_access_policy.storage,
  ]
}

resource "azurerm_storage_account_customer_managed_key" "custom-key" {
  storage_account_id = azurerm_storage_account.storage.id
  key_vault_id       = data.azurerm_key_vault.keyvault.id
  key_name           = azurerm_key_vault_key.state_key.name
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = var.storage_account_container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "lifecycle" {
  count              = var.storage_account_lifecycle_enabled ? 1 : 0
  storage_account_id = azurerm_storage_account.storage.id
  rule {
    name    = "Clenup"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      snapshot {
        change_tier_to_cool_after_days_since_creation = var.storage_account_lifecycle_rules.snapshot.change_tier_to_cool_after_days_since_creation
        delete_after_days_since_creation_greater_than = var.storage_account_lifecycle_rules.snapshot.delete_after_days_since_creation_greater_than
      }
      version {
        change_tier_to_cool_after_days_since_creation = var.storage_account_lifecycle_rules.version.change_tier_to_cool_after_days_since_creation
        delete_after_days_since_creation              = var.storage_account_lifecycle_rules.version.delete_after_days_since_creation
      }
    }
  }
}

resource "azurerm_role_assignment" "allow_to_access_terraform_state" {
  for_each             = toset(var.storage_account_allowed_groups_to_access_data)
  scope                = azurerm_storage_container.terraform_state.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azuread_group.allowed_groups_to_access[each.key].id
}

resource "azurerm_role_assignment" "allow_terraform_to_access_terraform_state" {
  for_each             = toset(var.storage_account_allowed_groups_to_access_data)
  scope                = azurerm_storage_container.terraform_state.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}