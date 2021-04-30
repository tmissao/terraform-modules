#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_eks_cluster" "eks-cluster" {
  name     = var.eks_cluster_identifier
  version  = var.eks_cluster_version
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    subnet_ids         = var.public_subnets_ids
    security_group_ids = [aws_security_group.eks-cluster.id]
  }

  tags = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }

  depends_on = [
    aws_iam_role_policy_attachment.allow-manage-services-amazon-eks-cluster-policy,
    aws_iam_role_policy_attachment.allow-manage-services-amazon-eks-service-policy,
  ]
}