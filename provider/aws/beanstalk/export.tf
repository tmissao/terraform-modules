module "ssm_arn" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key          = "${var.name}-arn"
  prefix       = "${var.ssm_prefix}-"
  value        = aws_elastic_beanstalk_application.application.arn
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}

module "ssm_cname" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key          = "${var.name}-cname"
  prefix       = "${var.ssm_prefix}-"
  value        = aws_elastic_beanstalk_environment.environment.cname
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}

module "ssm_load_balancers" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key          = "${var.name}-load_balancers"
  prefix       = "${var.ssm_prefix}-"
  value        = element(compact(list(join(",", aws_elastic_beanstalk_environment.environment.load_balancers), "not defined")), 0)
  type         = "StringList"
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}

module "ssm_endpoint_url" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key          = "${var.name}-endpoint_url"
  prefix       = "${var.ssm_prefix}-"
  value        = aws_elastic_beanstalk_environment.environment.endpoint_url
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}