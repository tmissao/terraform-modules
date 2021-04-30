output "parameter_name" {
  description = "SSM`s parameter name"
  value = element(compact(concat(aws_ssm_parameter.parameter.*.name, list(var.undefined_value))), 0)
}

output "parameter_arn" {
  description = "SSM`s parameter arn"
  value = element(compact(concat(aws_ssm_parameter.parameter.*.arn, list(var.undefined_value))), 0)
}