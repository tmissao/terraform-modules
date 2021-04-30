resource "aws_sqs_queue" "sqs_queue_error" {
  count                      = var.create_error_queue ? 1 : 0
  name                       = "${var.sqs_name}-error"
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  kms_master_key_id          = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  tags                       = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_sqs_queue" "sqs_queue" {
  name                       = var.sqs_name
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  redrive_policy = var.create_error_queue ? templatefile("${path.module}/redrive_policy.tmpl", {error_queue = element(compact(concat(aws_sqs_queue.sqs_queue_error.*.arn, list(var.undefined_value))), 0), max_count = var.max_receive_count }) : null
  kms_master_key_id          = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  tags                       = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}