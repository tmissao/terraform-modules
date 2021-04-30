resource "aws_lambda_function" "lambda" {
  filename = var.filename
  function_name = var.function_name
  handler = var.handler
  role = var.role
  description = var.description
  layers = var.layers
  memory_size = var.memory_size
  runtime = var.runtime
  timeout = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions
  source_code_hash = var.source_code_hash

  environment {
    variables = merge(var.environment, {"name" = var.function_name})
  }

  vpc_config {
    subnet_ids = var.vpc_subnet_ids
    security_group_ids = var.vpc_security_group_ids
  }

  tags = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}