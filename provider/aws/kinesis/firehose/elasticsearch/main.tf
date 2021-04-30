resource "aws_kinesis_firehose_delivery_stream" "elasticsearch" {
  name        = var.name
  destination = "elasticsearch"

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_stream_arn
    role_arn = var.role_arn
  }

  dynamic "s3_configuration" {
    for_each = var.s3_configuration
    content {
      role_arn = s3_configuration.value["role_arn"]
      bucket_arn = s3_configuration.value["bucket_arn"]
      buffer_size  = s3_configuration.value["buffer_size"]
      buffer_interval = s3_configuration.value["buffer_interval"]
      compression_format = s3_configuration.value["compression_format"]

      cloudwatch_logging_options { 
        enabled = s3_configuration.value.cloudwatch_logging_options.enabled
        log_group_name  = s3_configuration.value.cloudwatch_logging_options.enabled ? s3_configuration.value.cloudwatch_logging_options.log_group_name  : null
        log_stream_name = s3_configuration.value.cloudwatch_logging_options.enabled ? s3_configuration.value.cloudwatch_logging_options.log_stream_name : null
      }
    }
  }

  dynamic "elasticsearch_configuration" {
    for_each = var.elasticsearch_configuration
    content {
      domain_arn  = elasticsearch_configuration.value["domain_arn"]
      role_arn    = elasticsearch_configuration.value["role_arn"]
      index_name  = elasticsearch_configuration.value["index_name"]
      type_name   = elasticsearch_configuration.value["type_name"]
      index_rotation_period = elasticsearch_configuration.value["index_rotation_period"]
      buffering_size = elasticsearch_configuration.value["buffering_size"]
      buffering_interval = elasticsearch_configuration.value["buffering_interval"]

      cloudwatch_logging_options { 
        enabled = elasticsearch_configuration.value.cloudwatch_logging_options.enabled
        log_group_name  = elasticsearch_configuration.value.cloudwatch_logging_options.enabled ? elasticsearch_configuration.value.cloudwatch_logging_options.log_group_name  : null
        log_stream_name = elasticsearch_configuration.value.cloudwatch_logging_options.enabled ? elasticsearch_configuration.value.cloudwatch_logging_options.log_stream_name : null
      }
    }
  }

  tags = var.tags_shared
}