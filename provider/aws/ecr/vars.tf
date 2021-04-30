variable "namespace" { type = string }
variable "name" { type = string }
variable "policy" { default = null }
variable "create_policy" { default = false }
variable "tags_shared" {
  type = map(string)
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}