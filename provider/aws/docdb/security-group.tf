resource "aws_security_group" "docdb_client" {
  name        = "SGDocumentDb${title(var.docdb_cluster_identifier)}Client"
  description = "Allow To Connect DocumentDB ${title(var.docdb_cluster_identifier)}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.allowed_output_ips}"]
  }

  tags = merge(
          var.tags_shared,
          map( 
            "Name", "SGDocumentDb${title(var.docdb_cluster_identifier)}Client",
          )
        ) 

  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }       
}

resource "aws_security_group" "docdb" {
  name        = "SGDocumentDb${title(var.docdb_cluster_identifier)}"
  description = "SG For Document ${title(var.docdb_cluster_identifier)}"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = compact(
      list(
        aws_security_group.docdb_client.id,
        var.allowed_security_group_id == null ? "" : var.allowed_security_group_id
      )
    )
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowed_output_ips]
  }

  tags = merge(
          var.tags_shared,
          map( 
            "Name", "SGForDocument${title(var.docdb_cluster_identifier)}",
          )
        ) 
  
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }  
}
