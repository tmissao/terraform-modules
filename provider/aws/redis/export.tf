module "ssm_elasticache_primary_endpoint" {
  create = var.enable_ssm
  source = "../ssm"
  key    = "primary-endpoint"
  prefix = "${var.cluster_id}-"
  value  = "${aws_elasticache_replication_group.replication_group.primary_endpoint_address}"
  tags_shared = var.tags_shared
}

module "ssm_elasticache_port" {
  create = var.enable_ssm
  source = "../ssm"
  key    = "port"
  prefix = "${var.cluster_id}-"
  value  = "${aws_elasticache_replication_group.replication_group.port}"
  tags_shared = var.tags_shared
}

module "SsmClusterSgClient" {
  create = var.enable_ssm
  source = "../ssm"
  key = "sg-client"
  prefix = "${var.cluster_id}-"
  value = "${aws_security_group.client.id}"
  tags_shared = var.tags_shared
}