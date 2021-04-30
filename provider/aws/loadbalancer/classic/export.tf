module "ssm_arn" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key          = "${coalesce(var.name, var.name_prefix)}-arn"
  prefix       = "${var.ssm_prefix}-"
  value        = aws_elb.loadbalancer.arn
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}

module "ssm_name" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key          = "${coalesce(var.name, var.name_prefix)}-name"
  prefix       = "${var.ssm_prefix}-"
  value        = aws_elb.loadbalancer.name
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}

module "ssm_dns-name" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key          = "${coalesce(var.name, var.name_prefix)}-dnsname"
  prefix       = "${var.ssm_prefix}-"
  value        = aws_elb.loadbalancer.dns_name
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}