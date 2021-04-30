resource "aws_kinesis_stream" "default" {
  name             = var.name
  shard_count      = var.shard_count
  retention_period = var.retention_period

  shard_level_metrics = var.shard_level_metrics

  tags = var.tags_shared
}
