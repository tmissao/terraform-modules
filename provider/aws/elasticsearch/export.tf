module "ssm_cluster_arn" {
  create = var.enable_ssm
  source                     = "../ssm"
  key = "arn"
  prefix = "${var.domain_name}-"
  value = "${aws_elasticsearch_domain.elasticsearch.arn}"
  tags_shared = var.tags_shared
}

module "ssm_cluster_endpoint" {
  create = var.enable_ssm
  source                     = "../ssm"
  key = "endpoint"
  prefix = "${var.domain_name}-"
  value = "${aws_elasticsearch_domain.elasticsearch.endpoint}"
  tags_shared = var.tags_shared
}

module "ssm_cluster_kibana_endpoint" {
  create = var.enable_ssm
  source                     = "../ssm"
  key = "kibana-endpoint"
  prefix = "${var.domain_name}-"
  value = "${aws_elasticsearch_domain.elasticsearch.kibana_endpoint}"
  tags_shared = var.tags_shared
}