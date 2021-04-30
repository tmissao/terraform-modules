variable "docdb_cluster_instances" { default = 1 }
variable "docdb_cluster_identifier" { default = "docdb" }
variable "docdb_engine" { default = "docdb" }
variable "docdb_username" { default = "root" }
variable "docdb_password" { default = "root" }
variable "docdb_port" { default = "27017" }
variable "docdb_backup_retention_period" { default = "5" }
variable "docdb_preferred_backup_window" { default = "03:00-04:00" }
variable "docdb_preferred_maintenance_window" { default = "sun:05:00-sun:05:30" }
variable "docdb_cluster_instance_class" { default = "db.r5.large" }
variable "docdb_cluster_parameter_group_family" { default = "docdb3.6" }
variable "parameters" {
  type = list(object({
    name = string
    value = string
  }))
  default = []
}

variable "prefix" { default= "docdb"}

variable "allowed_output_ips" { default = "0.0.0.0/0" }

variable "tags_shared" {
  type = map(string)
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}

variable "vpc_id" { type = string }

variable "private_subnets_ids" { type = list(string) }

variable "shared_security_group" { default = false }

variable "allowed_security_group_id" { default = null }

variable "enable_ssm" { default = true }