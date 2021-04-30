output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "ssm_arn" {
  value =  module.ssm_arn.parameter_name
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "ssm_invoke_arn" {
  value = module.ssm_invoke_arn.parameter_name
}