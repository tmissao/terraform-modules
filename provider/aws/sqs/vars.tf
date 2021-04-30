variable "sqs_name" { type = string }

variable "delay_seconds" { default = 0 }
variable "max_message_size" { default = 262144 }
variable "message_retention_seconds" { default = 1209600 }
variable "receive_wait_time_seconds" { default = 0 }
variable "max_receive_count" { default = 5 }
variable "visibility_timeout_seconds" { default = 30 }
variable "kms_master_key_id" { default = null }
variable "kms_data_key_reuse_period_seconds" { default = 300 }
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
variable "create_error_queue" { default = true }
variable "undefined_value" { default = "undefined" }
