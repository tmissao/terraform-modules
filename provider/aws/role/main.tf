data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = var.actions
    principals {
      type        = var.principals_type
      identifiers = var.principals_identifiers
    }
  }
}

resource "aws_iam_role" "role" {
  name = var.name
  description = var.description
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
  force_detach_policies = var.force_detach_policies
  tags = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_iam_role_policy" "role_policy" {
  count = var.create_policy ? 1 : 0
  name = var.name
  role = aws_iam_role.role.id
  policy = var.policy
}

resource "aws_iam_instance_profile" "profile" {
  count = var.create_iam_instance_profile ? 1 : 0
  name = var.name
  role = aws_iam_role.role.id
}