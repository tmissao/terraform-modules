data "aws_subnet" "volume-subnet" {
  id = var.private_subnets_ids[0]
}

resource "aws_ebs_volume" "rancher-grafana" {
  count = var.eks_rancher_enable_monitoring ? 1 : 0
  availability_zone = var.eks_rancher_monitoring_options["volume_availability_zone"] != null ? ( 
                        var.eks_rancher_monitoring_options["volume_availability_zone"] ) : (
                        data.aws_subnet.volume-subnet.availability_zone
                      )
  size              = var.eks_rancher_monitoring_options["grafana_storage_gb"]
  tags = merge(
        var.tags_shared,
        map( 
          "Name", "EKS-${var.eks_cluster_identifier}-RancherGrafana",
        )
      ) 
}

resource "aws_ebs_volume" "rancher-prometheus" {
  count = var.eks_rancher_enable_monitoring ? 1 : 0
  availability_zone = var.eks_rancher_monitoring_options["volume_availability_zone"] != null ? ( 
                        var.eks_rancher_monitoring_options["volume_availability_zone"] ) : ( 
                        data.aws_subnet.volume-subnet.availability_zone
                      )
  size              = var.eks_rancher_monitoring_options["prometheus_storage_gb"]
  tags = merge(
        var.tags_shared,
        map( 
          "Name", "EKS-${var.eks_cluster_identifier}-RancherPrometheus",
        )
      ) 
}