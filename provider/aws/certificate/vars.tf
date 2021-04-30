variable "domain_name" { type = "string" }
variable "validation_method" { default = "DNS" }
variable "subject_alternative_names" { type = list(string) }

variable "tags_shared" {
  type = "map"
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}