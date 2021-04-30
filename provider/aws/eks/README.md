# AWS EKS Module

Este módulo ter por objetivo provisionar o recurso EKS, possibilitando caso necessário a instalação do Cluster AutoScaler, HPA, Istio e Rancher

# Utilização

```terraform
variable "eks_cluster_identifier" { default = "my-eks" }
variable "aws_access_key" { default = "<my-access-key>" }
variable "aws_secret_key" { default = "<my-secret-key>" }
variable "aws_region" { default = "us-east-1" }


module "vpc" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc"
  vpc_cidr_block             = "172.16.0.0/16"
  public_subnets_cidr_block  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets_cidr_block = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  // Add Tags for K8s auto-discover service
  is_eks_enabled             = true
  eks_name                   = var.eks_cluster_identifier
}

module "eks" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/eks"
  vpc_id                     = module.vpc.vpc_id
  private_subnets_ids        = module.vpc.private_subnets
  public_subnets_ids         = module.vpc.public_subnets
  eks_cluster_identifier     = var.eks_cluster_identifier
  aws_access_key             = var.aws_access_key
  aws_secret_key             =  var.aws_secret_key
  aws_region                 = var.aws_region
}
```

# Argumentos

* `vpc_id` - id da vpc onde será construido o EKS

* `private_subnets_ids` - lista de string contendo os ids das subnets privadas da vpc utilizada pelo EKS

* `public_subnets_ids` - lista de string contendo os ids das subnets públics da vpc utilizada pelo EKS

* `eks_cluster_identifier` - (Opcional) nome do cluster EKS. O valor padrão é "eks"

* `eks_cluster_version` - (Opcional) versão do EKS. O valor padrão é "1.18"

* `eks_cluster_allowed_ingress_ips` - (Opcional) Lista com asfaixa de Ips aos quais o EKS vai aceitar conexão. O valor padrão é "["0.0.0.0/0"]"

* `eks_nodes` - (Opcional) Lista de Mapa de valores representando os workers group nodes, contendo os seguintes argumentos:

    * label - Label a ser adicionados ao Kubelet dos nodes, o qual pode ser usando no nodeSelector.

    * instanceType - Tipo da EC2.

    * minSize - número mínimo de instâncias que devem ser mantido nesse node group.

    * desiredSize - número desejado de nodes que o este node group deve ter.

    * maxSize - número desejado de nodes que o este node group deve ter.

    * instanceOndemandBaseSize - número base de instancias (EC2) onDemand, o qual deve sempre ser mantido.

    * instanceOnDemandPercentagem - Porcentagem de instâncias onDemand que deseja ser mantido neste node group, este valor não leva em consideração o número de máquinas definido na propriedade `instanceOndemandBaseSize`

    * enableAutoScale - Indica que se esse node group pode ser escalado. Só é possível escalar um node group.

    O valor padrão é : 
    ```
    [ 
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
    ]
    ``` 

* `eks_manager_user_arn` - (Opcional) identificador arn do usuário IAM (AWS) que terá acesso ao cluster EKS. O valor padrão é "null".

* `eks_manager_user_name` - (Opcional) nome do usuário IAM (AWS) que terá acesso ao cluster EKS, essa variável deve representar o mesmo usuário indicado pela variável `eks_manager_user_arn`. O valor padrão é "null".

* `eks_install_hpa` - (Opcional) Indica se o Horizontal Node AutoScaler (HPA) deve ser instaldo. O valor padrão é "true".

* `eks_hpa_namespace` - (Opcional) Namespace onde o HPA será instalado. O valor padrão é "metrics".

* `eks_hpa_deployment_values_base64` - (Opcional) Valores utilizados para a instalação do HPA com Helm (values.yaml). O valor padrão é "null".

* `eks_install_cluster_autoscaller` - (Opcional) Indica se o ClusterAutoScaler (CA) deve ser instaldo. O valor padrão é "true".

* `eks_cluster-autoscaler_namespace` - (Opcional) Namespace onde o CA será instalado. O valor padrão é "metrics".

* `eks_cluster-autoscaler_deployment_values_base64` - (Opcional) Valores utilizados para a instalação do CA com Helm (values.yaml). O valor padrão é "null".

* `eks_install_istio` - (Opcional) Indica se o Istio (1.4.10) deve ser instaldo. O valor padrão é "true".

* `eks_istio_namespace` - (Opcional) Namespace onde o Istio será instalado. O valor padrão é "istio-system".

* `eks_istio_deployment_values_base64` - (Opcional) Valores utilizados para a instalação do Istio com Helm (values.yaml). O valor padrão é "null".

* `eks_install_rancher` - (Opcional) Indica se esse Cluster será associado/orquestrado pelo Rancher. O valor padrão é "true".

* `eks_rancher_deployment_path` - (Opcional) Caminho HTTP para a instalação do rancher operator no cluster. O valor padrão é "null"

* `eks_rancher_enable_monitoring` - (Opcional) Indica se esse Cluster será monitorado pelo Rancher. O valor padrão é "true".

* `eks_rancher_monitoring_options` - (Opcional) Mapa de valores com a configuração de persistência da monitoração do rancher:

    * volume_availability_zone - Availability Zone (AZ) em que os volumes (EBS) serão criados. Caso o valor seja "null" o volume será criado na primeira AZ denotada pela variável `private_subnets_ids`.

    * prometheus_storage_gb - Tamanho do EBS em GB que será associado ao Prometheus.

    * grafana_storage_gb - Tamanho do EBS em GB que será associado ao Grafana.

    O valor padrão é : 
    ```
   {
        "volume_availability_zone" = null
        "prometheus_storage_gb" =  50
        "grafana_storage_gb" = 10
   } 
    ``` 

* `eks_worker_nodes_custom_permissions` - (Opcional) Policy IAM que será associada aos node groups denotado pela variável `eks_nodes`.

* `aws_region` - região AWS onde o EKS será provisionado

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `eks_arn` - arn do cluster EKS

* `eks_id` - id do cluster EKS

* `eks_istio_loadbalancer_ssm_key` - chave SSM contendo o endereço DNS do loadbalance do cluster EKS

* `eks_client_security_group_id` - id do security group compartilhado do cluster EKS

# Outputs

Ao final da execução deste módulo o arquivo `temp/setup-eks.sh` é criado no diretório de execução, e este script deve ser executado pelo usuário que provisionou o EKS a fim de terminar a configuração do recurso, realizando os deploys necessários.