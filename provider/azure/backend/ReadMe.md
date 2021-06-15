# Azure Backend Module

This project intends to provision an Azure Terraform Backend following the best practices regards data replication, data access and disaster recovery.

## How to Use ?
---

```
module "backend" {
  source                                        = "../terraform-modules/azure-backend"
  resource_group_name                           = "my-resource-group"
  storage_account_name                          = "mystorageaccount"
  storage_account_allowed_ips                   = ["192.168.22.74"]
  keyvault                                      = { name = "keyvault-name", resource_group_name = "keyvault-rg" }
}
```

### See the [demo](./src/example) for full usage.

## Arguments
---
- `keyvault` - (Required) Keyvault's information used to encrypt the storage account.
  - `name` - (Required) Keyvault's name.
  - `resource_group_name` - (Required) Keyvault's resource group name.

- `resource_group_name` - (Required) Name of the resource group to be created.

- `resource_group_location` - (Optional) Location of the resource group. Defaults `brazilsouth`.

- `storage_account_name` - (Required) Storage's Account Name.

- `storage_account_tier` - (Optional) Storage's Account Tier. Defaults `Standard`.

- `storage_account_kind` - (Optional) Storage's Account Kind. Defaults `StorageV2`.

- `account_replication_type` - (Optional) Storage's Account Replication Strategy. Defaults `ZRS`.

- `storage_account_blob_versioning_enabled` - (Optional) Enables Blob Versioning in Storage Account. Defaults `true`.

- `storage_account_blob_delete_retention_days` - (Optional) Soft delete for blob in days. Defaults `7`.

- `storage_account_container_delete_retention_days` - (Optional) Soft delete for containers in days. Defaults `7`.

- `storage_account_allowed_ips` - (Optional) List of IPs allowed to access the storage account. Defaults `[]`.

- `storage_account_allowed_network_subnets_ids` - (Optional) List of Subnets' IDs allowed to access the storage account. Defaults `[]`. 

- `storage_account_container_name` - (Optional) Blob's Container name. Defaults `tfstate`.

- `storage_account_lifecycle_enabled` - (Optional) Enables lifecycle for blob containers. Defaults `true`.

- `storage_account_lifecycle_rules` - (Optional) Lifecycle's Rules for blob objects.

    Defaults

    ```
    {
      "snapshot": {
        "change_tier_to_cool_after_days_since_creation": 5
        "delete_after_days_since_creation_greater_than": 30
      }
      "version": {
        "change_tier_to_cool_after_days_since_creation":  5
        "delete_after_days_since_creation": 30
      }
    }
    ```

- `storage_account_allowed_groups_to_access_data` - (Optional) List of String representing the AD's Group Name which will have access to the blob container.

- `tags` - (Optional) Dictionary of string with the tags that will appended on each resource created.

## Output
---

- `resource_group_name` - Resource's Group Name

- `storage_account_name` - Storage's Account Name

- `container_name` - Blob's Container Name
