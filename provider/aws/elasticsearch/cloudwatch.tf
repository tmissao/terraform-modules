resource "aws_cloudwatch_log_group" "cloudwatch_log_elasticsearch" {
  name = "CWLogElasticsearch${title(var.domain_name)}"
   tags = var.tags_shared
}

resource "aws_cloudwatch_log_resource_policy" "cloudwatch_log_policy_elasticsearch" {
  policy_name = "CWLogPolicyElasticsearch${title(var.domain_name)}"

  policy_document = <<CONFIG
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "es.amazonaws.com"
        },
        "Action": [
            "logs:PutLogEvents",
            "logs:PutLogEventsBatch",
            "logs:CreateLogStream"
        ],
        "Resource": "arn:aws:logs:*"
        }
    ]
  }
  CONFIG
}
