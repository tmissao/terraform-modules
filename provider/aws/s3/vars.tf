variable "bucket" { type = string }
variable "acl" { default = "private" }

variable "tags_shared" {
  type = map(string)
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}

variable "enable_ssm" { default = true }
variable "block_public_acls" { default = true }
variable "block_public_policy" { default = true }
variable "ignore_public_acls" { default = true }
variable "restrict_public_buckets" { default = true }
variable "bucket_policy" { default = null }

/*
  {
    allowed_headers: list(string) , Optional
    allowed_methods: list(string) , Required
    allowed_origins: list(string) , Required
    expose_headers : list(string) , Optional
    max_age_seconds: number       , Optional
  }
*/
variable "cors_rules" {
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "lifecycle_rules" {
  type = list(object({
    id          = string
    prefix      = string
    enabled     = bool
    expiration  = object({ days = number })
  }))
  default = []
}