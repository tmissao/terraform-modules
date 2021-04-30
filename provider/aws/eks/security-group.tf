# Master Node
resource "aws_security_group" "eks-cluster" {
  name          = "EKS ${var.eks_cluster_identifier} Cluster Master Nodes"
  description   = "Cluster communication with worker nodes"
  vpc_id        = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
          var.tags_shared,
          map( "Name", "EKS ${var.eks_cluster_identifier}")
        )  
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  } 
}

resource "aws_security_group_rule" "eks-cluster-ingress-workstation-https" {
  cidr_blocks        = var.eks_cluster_allowed_ingress_ips
  description        = "Allow kubectl to communicate with the cluster API Server"
  from_port          = 443
  protocol           = "tcp"
  security_group_id  = aws_security_group.eks-cluster.id
  to_port            = 443
  type               = "ingress"
}
# --------------------------------------------------------------------------------------------------

# Worker Node
resource "aws_security_group" "eks-worker-node" {
  name          = "EKS ${var.eks_cluster_identifier} Workers Nodes"
  description   = "Security group for all nodes in the cluster ${var.eks_cluster_identifier}"
  vpc_id        = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = merge(
          var.tags_shared,
          map( 
            "Name", "${var.eks_cluster_identifier}-Workers-Nodes",
            "kubernetes.io/cluster/${var.eks_cluster_identifier}", "shared",
          )
        ) 
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }    
}

resource "aws_security_group" "eks-worker-node-client" {
  name        = "EKS${var.eks_cluster_identifier}Client"
  description = "Allow Connections from worker node on AWS Resources"
  vpc_id      = var.vpc_id

  tags = merge(
          var.tags_shared,
          map( 
            "Name", "EKS${var.eks_cluster_identifier}Client",
          )
        )    
        
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_security_group_rule" "eks-worker-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-worker-node.id
  source_security_group_id = aws_security_group.eks-worker-node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-worker-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-worker-node.id
  source_security_group_id = aws_security_group.eks-cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-worker-node-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-cluster.id
  source_security_group_id = aws_security_group.eks-worker-node.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow Cluster API Server to communicate with the PODs"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-worker-node.id
  source_security_group_id = aws_security_group.eks-cluster.id
  to_port                  = 443
  type                     = "ingress"
}