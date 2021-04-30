variable "cluster_id" { type = "string" }
variable "description" { default = "-" }
variable "engine" { default = "redis" }
variable "availability_zones" { type = list(string) }
variable "port" { default = 6379 }
variable "engine_version" { default = "5.0.5" }
variable "node_type" { default = "cache.t2.medium" }
variable "parameter_group_name" { default = "default.redis5.0" }
variable "snapshot_retention_limit" { default = 5 }
variable "snapshot_window" { default = "00:00-05:00" }
variable "number_cache_clusters" { default = 2 }

variable "tags_shared" {
  type = "map"
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}

variable "allowed_security_group_id" { default = null }
variable "enable_ssm" { default = true }
variable "allowed_output_ips" { default = "0.0.0.0/0" }
variable "vpc_id" { type = "string" }
variable "private_subnets_ids" { type = list(string) }