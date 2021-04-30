
module "role_ec2_start-stop_docdb" {
  source = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/role"
  name = "Lambda-${var.name}-Allow-Start-EC2"
  principals_identifiers = ["lambda.amazonaws.com"]
  policy = data.aws_iam_policy_document.lambda-start-ec2-permissions.json
  tags_shared = var.tags_shared
}

module "lambda" {
  source  = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/lambda"
  filename = "${path.module}/script-executor-lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/script-executor-lambda.zip")
  function_name = var.name
  handler = "src/index.handler"
  role = module.role_ec2_start-stop_docdb.arn
  runtime = "nodejs12.x"
  timeout = var.lambda_timeout
  environment = {
    EC2_NAME = var.ec2_name
    EC2_AMI = var.ec2_AMI
    EC2_PROFILE_ROLE = var.ec2_role_profile
    EC2_SUBNETS = join(",", var.ec2_subnet_ids)
    EC2_SECURITY_GROUPS = join(",", var.ec2_security_group_ids)
    S3_BUCKET = var.script_bucket_name
    S3_FILE_PATH = var.script_bucket_file_path
    S3_FILE_NAME = var.script_bucket_file_name
    TAG_KEYS = join(",", keys(var.tags_shared))
    TAG_VALUES = join(",", values(var.tags_shared))
  }
  tags_shared = var.tags_shared
}

resource "aws_cloudwatch_event_rule" "schedule-event" {
    name = "scheduled-script-${var.name}"
    schedule_expression = var.schedule_expression
    tags = var.tags_shared
    lifecycle {
      ignore_changes = [tags["data-criacao"]]
    }
}

resource "aws_cloudwatch_event_target" "fire_scheduled_script" {
    rule = aws_cloudwatch_event_rule.schedule-event.name
    arn = module.lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_lambda" {
    action = "lambda:InvokeFunction"
    function_name = var.name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.schedule-event.arn
}