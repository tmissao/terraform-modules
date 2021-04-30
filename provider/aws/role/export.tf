module "ssm_arn" {
  create      = var.enable_ssm
  source      = "../ssm"
  key         = "arn"
  prefix      = "${var.name}-"
  value       = aws_iam_role.role.arn
  tags_shared = var.tags_shared
}

module "ssm_iam_instance_profile_arn" {
  create      = var.enable_ssm
  source      = "../ssm"
  key         = "iam_instance_profile-arn"
  prefix      = "${var.name}-"
  value       = element(compact(concat(aws_iam_instance_profile.profile.*.arn, list(var.undefined_value))), 0)
  tags_shared = var.tags_shared
}

module "ssm_iam_instance_profile_name" {
  create      = var.enable_ssm
  source      = "../ssm"
  key         = "iam_instance_profile-name"
  prefix      = "${var.name}-"
  value       = element(compact(concat(aws_iam_instance_profile.profile.*.name, list(var.undefined_value))), 0)
  tags_shared = var.tags_shared
}
