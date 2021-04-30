output "arn" {
  description = "ARN for the created Amazon ElasticSearch"
  value =  "${aws_elasticsearch_domain.elasticsearch.arn}"
}

output "ssm_arn" {
  description = "SSM Key from Amazon ElasticSearch ARN"
  value =  "${module.ssm_cluster_arn.parameter_name}"
}

output "endpoint" {
  description = "Amazon ElasticSearch Endpoint"
  value =  "${aws_elasticsearch_domain.elasticsearch.endpoint}"
}

output "ssm_endpoint" {
  description = "SSM Key from Amazon ElasticSearch Endpoint"
  value =  "${module.ssm_cluster_endpoint.parameter_name}"
}

output "kibana_endpoint" {
  description = "Amazon ElasticSearch Kibana Endpoint"
  value =  "${aws_elasticsearch_domain.elasticsearch.kibana_endpoint}"
}

output "ssm_kibana_endpoint" {
  description = "SSM Key from Amazon ElasticSearch Kibana Endpoint"
  value =  "${module.ssm_cluster_kibana_endpoint.parameter_name}"
}