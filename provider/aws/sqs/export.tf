module "ssm_sqs_arn" {
  create = var.enable_ssm
  source  = "../ssm"
  key     = "arn"
  prefix  = "sqs-${var.sqs_name}-"
  value   = "${aws_sqs_queue.sqs_queue.arn}"
  tags_shared = var.tags_shared
}

module "ssm_sqs_url" {
  create  = var.enable_ssm
  source  = "../ssm"
  key     = "url"
  prefix  = "sqs-${var.sqs_name}-"
  value   = "${aws_sqs_queue.sqs_queue.id}"
  tags_shared = var.tags_shared
}

module "ssm_sqs_error_arn" {
  create  = var.enable_ssm && var.create_error_queue
  source  = "../ssm"
  key     = "arn"
  prefix  = "sqs-${var.sqs_name}-error-"
  value   = element(compact(concat(aws_sqs_queue.sqs_queue_error.*.arn, list(var.undefined_value))), 0)
  tags_shared = var.tags_shared
}

module "ssm_sqs_error_url" {
  create  = var.enable_ssm && var.create_error_queue
  source  = "../ssm"
  key     = "url"
  prefix  = "sqs-${var.sqs_name}-error-"
  value   = element(compact(concat(aws_sqs_queue.sqs_queue_error.*.id, list(var.undefined_value))), 0)
  tags_shared = var.tags_shared
}