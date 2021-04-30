resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  count = var.cloudwatch_create_alarm ? 1 : 0
  alarm_name                = "HighCpuUtilizationAlarm${replace(title(var.name),"-","")}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  threshold                 = var.cloudwatch_threshold
  alarm_description         = "CpuUtilization Threshold Exceeded ${var.cloudwatch_threshold}%"
  insufficient_data_actions = []
  alarm_actions             = var.cloudwatch_alarm_actions_sns_arn

  metric_query {
    id          = "mqbastion"
    return_data = true
    metric {
      metric_name = "CPUUtilizationBastion"
      namespace   = "AWS/EC2"
      period      = "300"
      stat        = "Maximum"
      unit        = "Percent"

      dimensions = {
        InstanceId = aws_instance.server.0.id
      }
    }
  }
  tags = var.tags_shared
}
