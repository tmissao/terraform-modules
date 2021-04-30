data "aws_iam_instance_profile" "iam-profile" {
  name = var.ec2_role_profile
}

data "aws_iam_policy_document" "lambda-start-ec2-permissions" {
  statement {
    actions = [
      "logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents", 
      "xray:PutTraceSegments", "xray:PutTelemetryRecords"
    ]
    resources = ["*"]
  }
  statement {
    actions = ["ec2:Describe*", "ec2:RunInstances", "ec2:CreateTags"]
    resources = ["*"]
  }
  statement {
    actions = ["iam:PassRole", "iam:GetRole"]
    resources = [data.aws_iam_instance_profile.iam-profile.role_arn]
  }
}