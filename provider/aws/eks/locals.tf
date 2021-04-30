locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-worker-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes 
CONFIGMAPAWSAUTH
  config_map_aws_auth_with_user_manager = <<CONFIGMAPAWSAUTHMANAGER
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-worker-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: ${var.eks_manager_user_arn != null ? var.eks_manager_user_arn : ""}
      username: ${var.eks_manager_user_name != null ? var.eks_manager_user_name : ""}
      groups:
        - system:masters 
CONFIGMAPAWSAUTHMANAGER
  config_autoscaller = templatefile("${path.module}/values/autoscaler-values.tmpl", { AWS_REGION = var.aws_region , CLUSTER_NAME = var.eks_cluster_identifier  } )
  kubernetes_tags = map(
    "kubernetes.io/cluster/${var.eks_cluster_identifier}", "owned"
  )
  kubernetes_autoscalling_tags = map(
    "k8s.io/cluster-autoscaler/${var.eks_cluster_identifier}", "owned",
    "k8s.io/cluster-autoscaler/enabled", "true"
  )
}

data "template_file" "shell-script" {
    template = "${file("${path.module}/scripts/setup.sh")}"
    vars = {
        CLUSTER_NAME = var.eks_cluster_identifier
        REGION = var.aws_region
        AWS_AUTH = base64encode(var.eks_manager_user_arn != null ? local.config_map_aws_auth_with_user_manager : local.config_map_aws_auth)
    }
}

data "template_file" "shell-hpa-script" {
    template = "${file("${path.module}/scripts/install_hpa.sh")}"
    vars = {
      INSTALL_HPA = var.eks_install_hpa ? 1 : 0
      HPA_NAMESPACE = var.eks_hpa_namespace
      HPA_VALUES = var.eks_hpa_deployment_values_base64 != null ? (
                    var.eks_hpa_deployment_values_base64) : ( 
                    base64encode(templatefile("${path.module}/values/hpa-values.tmpl", {} ))
                  )
    }
}

data "template_file" "shell-ca-script" {
    template = "${file("${path.module}/scripts/install_cluster_autoscaler.sh")}"
    vars = {
      INSTALL_CA = var.eks_install_cluster_autoscaller ? 1 : 0
      CA_NAMESPACE = var.eks_cluster-autoscaler_namespace
      CA_VALUES = var.eks_cluster-autoscaler_deployment_values_base64 != null ? (
                    var.eks_cluster-autoscaler_deployment_values_base64) : ( 
                    base64encode(templatefile("${path.module}/values/autoscaler-values.tmpl", { AWS_REGION = var.aws_region , CLUSTER_NAME = var.eks_cluster_identifier  } ))
                  )
    }
}

data "template_file" "shell-istio-script" {
    template = "${file("${path.module}/scripts/install_istio.sh")}"
    vars = {
      INSTALL_ISTIO = var.eks_install_istio ? 1 : 0
      ISTIO_NAMESPACE = var.eks_istio_namespace
      ISTIO_VALUES = var.eks_istio_deployment_values_base64 != null ? (
                        var.eks_istio_deployment_values_base64 ) : ( 
                        base64encode(templatefile("${path.module}/values/istio-values.tmpl", { TAGS = join(",", formatlist("%s=%s", keys(var.tags_shared), values(var.tags_shared))) } ))
                      )
      
      CLUSTER_NAME = var.eks_cluster_identifier
    }
}

data "template_file" "shell-rancher-script" {
    template = "${file("${path.module}/scripts/install_rancher.sh")}"
    vars = {
      INSTALL_RANCHER = var.eks_install_rancher ? 1 : 0
      RANCHER_DEPLOYMENT_PATH = var.eks_rancher_deployment_path
      INSTALL_RANCHER_MONITORING = var.eks_rancher_enable_monitoring ? 1 : 0
      RANCHER_VOLUMES = base64encode(templatefile("${path.module}/values/rancher-volumes.tmpl", { 
        GRAFANA_VOLUME_ID = element(compact(concat(aws_ebs_volume.rancher-grafana.*.id, list("not-defined"))), 0)
        GRAFANA_STORAGE_SIZE = var.eks_rancher_monitoring_options["grafana_storage_gb"], 
        PROMETHEUS_VOLUME_ID = element(compact(concat(aws_ebs_volume.rancher-prometheus.*.id, list("not-defined"))), 0), 
        PROMETHEUS_STORAGE_SIZE = var.eks_rancher_monitoring_options["prometheus_storage_gb"]   
      }))
    }
}

data "template_file" "shell-fluentbit-script" {
    template = "${file("${path.module}/scripts/install_fluentbit.sh")}"
    vars = {
      INSTALL_FLUENTBIT = var.efk_elasticsearch_install ? 1 : 0
      FLUENTBIT_NAMESPACE = var.efk_namespace
      FLUENTBIT_OUTPUT = base64encode(templatefile("${path.module}/values/fluentbit.tmpl", { 
        ES_ENDPOINT = var.efk_elasticsearch_endpoint
        AWS_REGION  = var.aws_region
      }))
    }
}

data "template_file" "shell-custom-metrics-cloudwatch-script" {
    template = "${file("${path.module}/scripts/install_cloudwatch_metrics.sh")}"
    vars = {
      INSTALL_CUSTOM_METRICS_CLOUDWATCH = var.eks_install_custom_metrics_cloudwatch ? 1 : 0
      CUSTOM_METRICS_CLOUDWATCH_DEPLOYMENT = base64encode(templatefile("${path.module}/values/cloudwatch-adapter.yaml", {}))
    }
}

resource "local_file" "setup-eks" {
    content     = join("\n", [
      data.template_file.shell-script.rendered,
      data.template_file.shell-hpa-script.rendered,
      data.template_file.shell-ca-script.rendered,
      data.template_file.shell-istio-script.rendered,
      data.template_file.shell-rancher-script.rendered,
      data.template_file.shell-fluentbit-script.rendered,
      data.template_file.shell-custom-metrics-cloudwatch-script.rendered
    ])
    filename = "temp/setup-eks.sh"
    file_permission = "0755"
}
