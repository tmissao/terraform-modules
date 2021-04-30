output "arn" {
  description = "ARN for the created Amazon SNS"
  value =  "${aws_sns_topic.sns_topic.arn}"
}

output "ssm_arn" {
  description = "SSM Key for SNS"
  value = module.ssm_sns_arn.parameter_name
}

output "name" {
  description = "SSM Key for SNS"
  value = aws_sns_topic.sns_topic.name
}
