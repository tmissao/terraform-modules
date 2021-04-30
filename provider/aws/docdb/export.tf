module "SsmClusterSgClient" {
  create = var.enable_ssm
  source                     = "../ssm"
  key = "sg-client"
  prefix = "${var.prefix}-${var.docdb_cluster_identifier}-"
  value = "${aws_security_group.docdb_client.id}"
  tags_shared = var.tags_shared
}

module "SsmClusterEndPoint" {
  create = var.enable_ssm
  source                     = "../ssm"
  key = "endpoint"
  prefix = "${var.prefix}-${var.docdb_cluster_identifier}-"
  value = "${aws_docdb_cluster.docdb.endpoint}"
  tags_shared = var.tags_shared
}

module "SsmClusterReaderEndPoint" {
  create = var.enable_ssm
  source                     = "../ssm"
  key = "reader-endpoint"
  prefix = "${var.prefix}-${var.docdb_cluster_identifier}-"
  value = "${aws_docdb_cluster.docdb.reader_endpoint}"
  tags_shared = var.tags_shared
}

module "SsmClusterPort" {
  create = var.enable_ssm
  source                     = "../ssm"
  key = "port"
  prefix = "${var.prefix}-${var.docdb_cluster_identifier}-"
  value = "${var.docdb_port}"
  tags_shared = var.tags_shared
}

module "SsmClusterUsername" {
  create = var.enable_ssm
  source                     = "../ssm"
  key = "username"
  prefix = "${var.prefix}-${var.docdb_cluster_identifier}-"
  value = "${var.docdb_username}"
  tags_shared = var.tags_shared
}

module "SsmClusterPassword" {
  create = var.enable_ssm
  source                     = "../ssm"
  key = "password"
  prefix = "${var.prefix}-${var.docdb_cluster_identifier}-"
  value = "${var.docdb_password}"
  tags_shared = var.tags_shared
}