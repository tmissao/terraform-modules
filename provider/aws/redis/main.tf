resource "aws_elasticache_replication_group" "replication_group" {
  replication_group_id          = var.cluster_id
  replication_group_description = var.description
  engine                        = var.engine
  engine_version                = var.engine_version
  node_type                     = var.node_type
  port                          = var.port
  number_cache_clusters         = var.number_cache_clusters
  
  security_group_ids            = [ aws_security_group.elasticache.id ]
  
  subnet_group_name             = aws_elasticache_subnet_group.subnet_group.name

  parameter_group_name          = var.parameter_group_name

  automatic_failover_enabled    = true
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = false

  snapshot_retention_limit      = var.snapshot_retention_limit
  snapshot_window               = var.snapshot_window

  lifecycle {
    ignore_changes = ["number_cache_clusters", tags["data-criacao"]]
  }  

  tags                          = var.tags_shared
}

resource "aws_elasticache_cluster" "elasticache_cluster" {
  count = 1
  cluster_id           = "${var.cluster_id}-rep-group-${count.index}"
  replication_group_id = aws_elasticache_replication_group.replication_group.id
  tags                          = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}