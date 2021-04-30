variable "domain_name" { default = "elasticsearch-default" }
variable "elasticsearch_version" { default = "7.4" }
variable "instance_type" { default = "r5.large.elasticsearch" }
variable "instance_count" { default = 1 }
variable "create_linked_role"  { default = 1 }

variable "volume_size" { default = 10 }
variable "volume_type" { default = "gp2" }
variable "automated_snapshot_start_hour" { default = "00" }

variable "vpc_options" {
  type = list(object({
    subnet_ids = list(string)
    security_group_ids = list(string)
  }))
  description = "VPC Options"
  default     = []
}

variable "access_policies" { type = "string" }

variable "enforce_https" { default = false }

variable "tls_security_policy" { default = "Policy-Min-TLS-1-0-2019-07" }

variable "encrypt_enabled" { default = false }

variable "node_encrypt_enabled" { default = false }

variable "enable_ssm" { default = true }

variable "tags_shared" {
  type = "map"
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}