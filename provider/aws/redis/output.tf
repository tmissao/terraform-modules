output "primary_endpoint" {
  value = "${aws_elasticache_replication_group.replication_group.primary_endpoint_address}"
}

output "port" {
  value = "${aws_elasticache_replication_group.replication_group.port}"
}

output "sg_client_id" {
  value =  aws_security_group.client.id
}

output "ssm_sg_client_id" {
  value =  module.SsmClusterSgClient.parameter_name
}