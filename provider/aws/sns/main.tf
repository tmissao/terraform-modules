data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "iam-policy-document" {
  policy_id = "__${var.sns_name}_iam_policy_document_policy_ID"
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission"
    ]
    condition {
      test = "StringEquals"
      variable = "AWS:SourceOwner"
      values = length(var.allowed_accounts) == 0 ? [data.aws_caller_identity.current.account_id] : var.allowed_accounts
    }
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    resources = [
      "${aws_sns_topic.sns_topic.arn}",
    ]
    sid = "__${var.sns_name}_iam_policy_document_statement_ID"
  }
}

resource "aws_sns_topic" "sns_topic" {
  name = var.sns_name
  delivery_policy = var.delivery_policy
  tags = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn = aws_sns_topic.sns_topic.arn
  policy = var.sns_policy == null ? "${data.aws_iam_policy_document.iam-policy-document.json}" : var.sns_policy
}

resource "aws_sns_topic_subscription" "sqs_subscriptions" {
  count = length(var.sqs_arns_subscriptions)
  protocol = "sqs"
  raw_message_delivery = var.sqs_subscription_raw_delivery
  topic_arn = aws_sns_topic.sns_topic.arn
  endpoint = element(var.sqs_arns_subscriptions, count.index)
}

resource "aws_sns_topic_subscription" "endpoint_subscriptions" {
  count = length(var.endpoints_subscriptions)
  protocol = "https"
  raw_message_delivery = var.endpoint_subscription_raw_delivery
  topic_arn = aws_sns_topic.sns_topic.arn
  endpoint = element(var.endpoints_subscriptions, count.index)
}
