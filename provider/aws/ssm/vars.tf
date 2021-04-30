variable "prefix" { default = "" }
variable "sufix" { default = "" }
variable "description" { default = "-" }
variable "type" { default = "String" }
variable "key" { }
variable "value" { }
variable "create" { default = true }
variable "overwrite" { default = true }
variable "tags_shared" {
  type = map(string)
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}
variable "undefined_value" { default = "undefined" }