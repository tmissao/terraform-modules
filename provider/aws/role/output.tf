output "name" {
  description = "Role Name"
  value =  aws_iam_role.role.name
}

output "arn" {
    description = "Role Arn"
    value = aws_iam_role.role.arn
}

output "ssm_arn" {
  description = "SSM Key from Role ARN"
  value =  module.ssm_arn.parameter_name
}

output "iam_instance_profile_arn" {
  description = "ARN for IAM Instance Profile"
  value = element(compact(concat(aws_iam_instance_profile.profile.*.arn, list(var.undefined_value))), 0)
}

output "iam_instance_profile_name" {
  description = "name for IAM Instance Profile"
  value = element(compact(concat(aws_iam_instance_profile.profile.*.name, list(var.undefined_value))), 0)
}

output "ssm_iam_instance_profile_arn" {
  description = "SSM Key from IAM Instance Profile ARN"
  value =  module.ssm_iam_instance_profile_arn.parameter_name
}

output "ssm_iam_instance_profile_name" {
  description = "SSM Key from IAM Instance Profile ARN"
  value =  module.ssm_iam_instance_profile_name.parameter_name
}
