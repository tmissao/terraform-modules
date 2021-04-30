resource "aws_iam_user" "user" {
  name   = var.user_name
  tags   = var.tags_shared  
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_iam_access_key" "user_access_key" {
  user   = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "user_policy" {
  user   = aws_iam_user.user.name
  policy = var.user_policy
}
