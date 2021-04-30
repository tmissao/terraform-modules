resource "aws_security_group" "elasticache" {
  name          = "SGForElastiCache${title(var.cluster_id)}"
  description   = "SG For ElastiCache ${title(var.cluster_id)}"
  vpc_id        = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     =var.port
    protocol    = "tcp"
    security_groups = compact(
      list(
        aws_security_group.client.id,
        var.allowed_security_group_id == null ? "" : var.allowed_security_group_id
      )
    )
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.allowed_output_ips}"]
  }
  tags = merge(
          var.tags_shared,
          map( 
            "Name", "SGForElastiCache${title(var.cluster_id)}",
          )
        ) 
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_security_group" "client" {
  name          = "SGForElastiCache${title(var.cluster_id)} Client"
  description   = "SG For ElastiCache ${title(var.cluster_id)} Client"
  vpc_id        = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.allowed_output_ips}"]
  }

  tags = merge(
          var.tags_shared,
          map( 
          "Name", "SGDocumentDb${title(var.cluster_id)}Client",
          )
        ) 
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }   
}