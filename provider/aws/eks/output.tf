output "eks_arn" {
  description = "ARN for the created Amazon EKS Cluster"
  value =  aws_eks_cluster.eks-cluster.arn
}

output "eks_id" {
  description = "ID for the created Amazon EKS Cluster"
  value =  aws_eks_cluster.eks-cluster.id
}

output "eks_client_security_group_id" {
  description = "ID of nodes security group allowing to connect on AWS resources"
  value = aws_security_group.eks-worker-node-client.id
}

output "eks_istio_loadbalancer_ssm_key" {
  value = "eks-${var.eks_cluster_identifier}-istio-loadbalancer"
}