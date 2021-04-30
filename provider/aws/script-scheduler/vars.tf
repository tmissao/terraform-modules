variable "name" { type = string }
variable "tags_shared" { 
  type = map(string)
  default = { 
    "Terraform": true
  }
}
variable "ec2_name" { type = string }
variable "ec2_AMI" { type = string }
variable "ec2_subnet_ids" { type = list(string) }
variable "ec2_security_group_ids" { type = list(string) }
variable "ec2_role_profile" { type = string }
variable "script_bucket_name" { type = string }
variable "script_bucket_file_path" { type = string }
variable "script_bucket_file_name" { type = string }
variable "schedule_expression" { type = string }
variable "lambda_timeout" { default = 180 }
