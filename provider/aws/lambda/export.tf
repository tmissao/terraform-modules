module "ssm_arn" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key          = "${var.function_name}-arn"
  prefix       = "${var.ssm_prefix}-"
  value        = aws_lambda_function.lambda.arn
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}

module "ssm_invoke_arn" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key          = "${var.function_name}-invoke_arn"
  prefix       = "${var.ssm_prefix}-"
  value        = aws_lambda_function.lambda.invoke_arn
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}