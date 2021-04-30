variable "tags_shared" {
  type = "map"
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}

variable "s3_folders" {
  type        = "list"
  description = "S3 folders to create"
  default     = ["providers", "reports"]
}

variable "bucket_name" {}
variable "dynamo_table_name" {}