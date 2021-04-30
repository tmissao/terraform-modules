# AWS Elasticsearch Module

Este módulo ter por objetivo provisionar o recurso Elasticsearch

# Utilização

```terraform
data "aws_iam_policy_document" "permissions" {
  statement {
    actions = ["es:*"]
    resources = ["*"]
  }
}

module "vpc" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc"
  vpc_cidr_block             = "172.16.0.0/16"
  public_subnets_cidr_block  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets_cidr_block = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}

module "elasticsearch" {
  source                = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/elasticsearch"
  domain_name           = "my-elasticsearch"
  elasticsearch_version = "7.4"
  instance_type         = "r5.large.elasticsearch"
  instance_count        = 1

  volume_size  = 10
  volume_type  = "gp2"
  automated_snapshot_start_hour = "00"

  vpc_options = [{ 
    subnet_ids = module.vpc.private_subnets
  }]

  access_policies  = data.aws_iam_policy_document.permissions.json
}
```

# Argumentos

* `domain_name` - nome do domínio do Elasticsearch

* `elasticsearch_version` - (Opcional) versão do Elasticsearch. O valor padrão é 7.4

* `cluster_config` suporta os seguintes atributos:

  * `instance_type` - (Opcional) tipo de instâncias de nodes do cluster. O valor padrão é r5.large.

  * `instance_count` - (Opcional) número de instâncias no cluster. O valor padrão é 1

* `ebs_options` suporta os seguintes atributos:

  * `volume_type` - (Opcional) tipo de volumes EBS anexados aos nodes. O valor padrão é gp2

  * `volume_size` - tamanho dos volumes EBS anexados aos nodes (em GB). O valor padrão é 10

* `snapshot_options` suporta o seguinte atributo:

  * `automated_snapshot_start_hour` - hora a qual o serviço tira um `snapshot` diário automatizado dos índices do domínio. O valor padrão é 00

* `vpc_options` suporta os seguintes atributos: 

  * `security_group_ids` - (Opcional) lista de ids das Security Groups que serão associadas ao Elasticsearch. O valor padrão é []. Caso seja omitido, o grupo de segurança padrão será usado pela VPC.

  * `subnet_ids` - lista de ids das subnets onde o Elasticsearch será executado. O valor padrão é [].

* `domain_endpoint_options` suporta os seguintes atributos:  

  * `enforce_https` - habilitar HTTPS. O valor padrão é false.

  * `tls_security_policy` - (Opcional) nome da política de segurança TLS que precisa ser aplicada ao endpoint HTTPS. O valor padrão é Policy-Min-TLS-1-0-2019-07.

* `encrypt_at_rest` suporta o seguinte atributo:

  * `encrypt_enabled` - ativa a criptografia em repouso. O valor padrão é false.
 
* `node_to_node_encryption` suporta o seguinte atributo:

  * `node_encrypt_enabled` - ativa a criptografia entre os nodes. O valor padrão é false.

* `access_policies` - (Opcional) políticas de acesso do IAM para o domínio.

* `tags_shared` - (Opcional) mapa de string, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `arn` - arn do Elasticsearch

* `endpoint` - endpoint do Elasticsearch

* `kibana_endpoint` -  endpoint do Kibana sem scheme https

* `ssm_arn` - chave ssm com valor `arn` do Elasticsearch

* `ssm_endpoint` - chave ssm com valor `endpoint` do Elasticsearch

* `ssm_kibana_endpoint` - chave ssm com valor `endpoint` do Kibana