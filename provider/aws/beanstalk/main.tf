resource "aws_elastic_beanstalk_application" "application" {
  name        = var.name
  description = var.description
  tags = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}
resource "aws_elastic_beanstalk_environment" "environment" {
  name = var.name
  description = var.description
  application = aws_elastic_beanstalk_application.application.name
  solution_stack_name = var.solution_stack_name
  tier = var.tier
  cname_prefix = var.cname_prefix

  dynamic "setting" {
    for_each = var.settings
    content {
      namespace = setting.value["namespace"]
      name  = setting.value["name"]
      value = setting.value["value"]
      resource = setting.value["resource"]
    }
  }

  tags = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}