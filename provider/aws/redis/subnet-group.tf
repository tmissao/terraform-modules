resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = "${var.cluster_id}"
  subnet_ids = "${var.private_subnets_ids}"
}