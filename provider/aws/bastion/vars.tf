variable "ssh_public_key_path" { default = "/keys/bastion-key.pub" }
variable "ssh_private_key_path" { default = "/keys/bastion-key.pk" }
variable "ssh_key_name" { default = "bastion-key" }
variable "vpc_id" { type = string }
variable "public_subnets_ids" { type = list(string) }
variable "allowed_ips_to_ssh" { default = ["0.0.0.0/0"] }
variable "instance_type" { default = "t3.medium" }
variable "name" { default = "default" }
variable "allowed_security_group_id" { default = null }
variable "create" { default = true }
variable "undefined_value" { default = "undefined" }
variable "tags_shared" {
  type = map(string)
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}

variable "cloudwatch_create_alarm" { default = false }
variable "cloudwatch_threshold"    { default = 70 }
variable "cloudwatch_alarm_actions_sns_arn"  { default = [] }