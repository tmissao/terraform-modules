resource "aws_docdb_cluster" "docdb" {
  cluster_identifier              = var.docdb_cluster_identifier
  engine                          = var.docdb_engine
  master_username                 = var.docdb_username
  master_password                 = var.docdb_password
  port                            = var.docdb_port
  enabled_cloudwatch_logs_exports = ["audit"]
  skip_final_snapshot = true
  storage_encrypted               = true
  backup_retention_period         = var.docdb_backup_retention_period
  preferred_backup_window         = var.docdb_preferred_backup_window
  apply_immediately               = true
  preferred_maintenance_window    = var.docdb_preferred_maintenance_window
  db_subnet_group_name            = aws_docdb_subnet_group.subnet_group.id
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb_parameter_group.id
  vpc_security_group_ids          = [aws_security_group.docdb.id]

  tags = merge(
          var.tags_shared,
          map( 
            "Name", "Cluster Docdb ${title(var.docdb_cluster_identifier)}",
          )
        ) 
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.docdb_cluster_instances
  identifier         = "${var.docdb_cluster_identifier}-${count.index}"
  cluster_identifier = element(aws_docdb_cluster.docdb.*.id, count.index)
  instance_class     = var.docdb_cluster_instance_class
  apply_immediately  = true

  tags = merge(
          var.tags_shared,
          map( 
            "Name", "Cluster Instance Docdb",
          )
        ) 
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_docdb_subnet_group" "subnet_group" {
  name       = "docdb-subnet-group-${lower(var.docdb_cluster_identifier)}"
  subnet_ids = var.private_subnets_ids

  tags = merge(
          var.tags_shared,
          map( 
            "Name", "Subnet Group Docdb",
          )
        ) 
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_docdb_cluster_parameter_group" "docdb_parameter_group" {
  family      = var.docdb_cluster_parameter_group_family
  name        = "docdb-parameter-group-${lower(var.docdb_cluster_identifier)}"
  description = "Default cluster parameter group for docdb3.6"
  tags =  merge(
            var.tags_shared,
            map( 
              "Name", "Parameter Group Docdb",
            )
          ) 
     
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  } 
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name = parameter.value["name"]
      value = parameter.value["value"]
    }
  }
}
