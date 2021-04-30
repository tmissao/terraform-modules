output "arn" {
  description = "ARN for the created Amazon SQS queue"
  value =  "${aws_sqs_queue.sqs_queue.arn}"
}

output "ssm_arn" {
  description = "SSM Key from Amazon SQS ARN"
  value =  "${module.ssm_sqs_arn.parameter_name}"
}

output "url" {
  description = "URL for the created Amazon SQS queue"
  value =  "${aws_sqs_queue.sqs_queue.id}"
}

output "ssm_url" {
  description = "SSM Key from Amazon SQS Url"
  value =  "${module.ssm_sqs_url.parameter_name}"
}

output "error_arn" {
  description = "ARN for the created Amazon SQS error queue"
  value = element(compact(concat(aws_sqs_queue.sqs_queue_error.*.arn, list(var.undefined_value))), 0)
}

output "ssm_error_arn" {
  description = "SSM Key from Amazon SQS error ARN"
  value =  "${module.ssm_sqs_error_arn.parameter_name}"
}

output "error_url" {
  description = "URL for the created Amazon SQS error queue"
  value = element(compact(concat(aws_sqs_queue.sqs_queue_error.*.id, list(var.undefined_value))), 0)
}

output "ssm_error_url" {
  description = "SSM Key from Amazon SQS error Url"
  value =  "${module.ssm_sqs_error_url.parameter_name}"
}

output "id" {
  description = "ID for the created Amazon SQS queue"
  value =  "${aws_sqs_queue.sqs_queue.id}"
}
