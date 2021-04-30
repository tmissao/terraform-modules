variable "vpc_id" { type = string }
variable "private_subnets_ids" { type = list(string) }
variable "public_subnets_ids"  { type = list(string) }
variable "aws_region" { type = string }
variable "eks_cluster_identifier" { default= "eks"}
variable "eks_cluster_version" { default = "1.18" }
variable "eks_cluster_allowed_ingress_ips" { default = ["0.0.0.0/0"] }
variable "eks_security_groups_ids" { default = [] }
variable "eks_nodes" { default = [ 
    {
        "label" = "worker"
        "instanceType" = "m5.large"
        "minSize" = 1
        "desiredSize" = 1
        "maxSize" = 2
        "instanceOndemandBaseSize" = 1
        "instanceOnDemandPercentagem" = 100
        "enableAutoScale" = true
    }
 ]}
variable "eks_manager_user_arn" { default = null }
variable "eks_manager_user_name" { default = null }

variable "eks_install_hpa" { default = true }
variable "eks_hpa_namespace" { default = "metrics" }
variable "eks_hpa_deployment_values_base64" { default = null }
variable "eks_install_cluster_autoscaller" { default = true }
variable "eks_cluster-autoscaler_namespace" { default = "metrics" }
variable "eks_cluster-autoscaler_deployment_values_base64" { default = null }
variable "eks_install_istio" { default = true }
variable "eks_istio_namespace" { default = "istio-system" }
variable "eks_istio_deployment_values_base64" { default = null }
variable "eks_install_rancher" { default = true }
variable "eks_rancher_deployment_path" { default = "" }
variable "eks_rancher_enable_monitoring" { default = true }
variable "eks_rancher_monitoring_options" { 
    default = {
        "volume_availability_zone" = null
        "prometheus_storage_gb" =  50
        "grafana_storage_gb" = 10
    } 
}
variable "eks_install_custom_metrics_cloudwatch" { default = true }
variable "efk_elasticsearch_install"  { default = false }
variable "efk_elasticsearch_endpoint" { default = "null" }
variable "efk_namespace" { default = "logging" }

variable "tags_shared" { type = map }

variable "eks_worker_nodes_custom_permissions" {
  default = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sns:*",
                "sqs:*",
                "s3:*",
                "sms:*",
                "kinesis:PutRecord",
                "kinesis:PutRecords",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords",
                "lambda:InvokeFunction",
                "lambda:InvokeAsync",
                "cloudwatch:GetMetricData"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}