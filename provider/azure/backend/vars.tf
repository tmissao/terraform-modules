variable "keyvault" {
  type = object({ name = string, resource_group_name = string })
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type    = string
  default = "brazilsouth"
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_tier" {
  type    = string
  default = "Standard"
}

variable "storage_account_kind" {
  type    = string
  default = "StorageV2"
}

variable "account_replication_type" {
  type    = string
  default = "ZRS"
}

variable "storage_account_blob_versioning_enabled" {
  type    = bool
  default = true
}

variable "storage_account_blob_delete_retention_days" {
  type    = number
  default = 7
}

variable "storage_account_container_delete_retention_days" {
  type    = number
  default = 7
}

variable "storage_account_allowed_ips" {
  type    = list(string)
  default = []
}

variable "storage_account_allowed_network_subnets_ids" {
  type    = list(string)
  default = []
}

variable "storage_account_container_name" {
  type    = string
  default = "tfstate"
}

variable "storage_account_lifecycle_enabled" {
  type    = bool
  default = true
}

variable "storage_account_lifecycle_rules" {
  type = object({
    snapshot = object({
      change_tier_to_cool_after_days_since_creation = number,
      delete_after_days_since_creation_greater_than = number
    }),
    version = object({
      change_tier_to_cool_after_days_since_creation = number,
      delete_after_days_since_creation              = number
    })
  })
  default = {
    "snapshot" : {
      "change_tier_to_cool_after_days_since_creation" : 5
      "delete_after_days_since_creation_greater_than" : 30
    }
    "version" : {
      "change_tier_to_cool_after_days_since_creation" : 5
      "delete_after_days_since_creation" : 30
    }
  }
}

variable "storage_account_allowed_groups_to_access_data" {
  type    = list(string)
  default = []
}

variable "tags" {
  type = map(string)
  default = {
    "terraform" : "true"
  }
}