module "ssm_sns_arn" {
  source       = "../ssm"
  key          = "arn"
  prefix       = "sns-${var.sns_name}-"
  value        = "${aws_sns_topic.sns_topic.arn}"
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}