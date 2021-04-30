resource "aws_elasticsearch_domain" "elasticsearch" {
  depends_on = ["aws_iam_service_linked_role.elasticsearch_service_linked_role"]

  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  dynamic "vpc_options" {
    for_each = var.vpc_options
    content {
      subnet_ids         = vpc_options.value["subnet_ids"]
      security_group_ids = vpc_options.value["security_group_ids"]
    }
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  domain_endpoint_options {
     enforce_https = var.enforce_https
     tls_security_policy = var.tls_security_policy
  }

  encrypt_at_rest {
     enabled = var.encrypt_enabled
  }

  node_to_node_encryption {
     enabled = var.node_encrypt_enabled
  }

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.cloudwatch_log_elasticsearch.arn}"
    log_type = "INDEX_SLOW_LOGS"
  }

  access_policies = var.access_policies

  tags = "${
      merge(
        var.tags_shared,
        map(        
          "Name", "Cluster Instance ${title(var.domain_name)}",
        )
      ) 
  }"   
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}
