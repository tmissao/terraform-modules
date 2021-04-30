resource "aws_kinesis_firehose_delivery_stream" "s3" {
  name        = var.name
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_stream_arn
    role_arn = var.role_arn
  }

  extended_s3_configuration {
    role_arn           = var.role_arn
    bucket_arn         = var.bucket_arn
    buffer_size        = var.buffer_size
    buffer_interval    = var.buffer_interval
    compression_format = var.compression_format

    cloudwatch_logging_options {
      enabled         = var.enabled
      log_group_name  = var.log_group_name
      log_stream_name = var.log_stream_name
    }
  }

  tags = var.tags_shared
}