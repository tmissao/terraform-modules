resource "aws_ecr_repository" "repository" {
  name  = "${var.namespace}/${var.name}"
  tags  = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_ecr_repository_policy" "policy" {
  count = var.create_policy ? 1 : 0
  repository = aws_ecr_repository.repository.name
  policy = var.policy == null ? "" : var.policy
}