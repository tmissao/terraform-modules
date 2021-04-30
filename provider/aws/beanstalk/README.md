# AWS BeanStalk

Este módulo ter por objetivo provisionar o recurso BeanStalk, exportando seus parametros via SSM

# Utilização

```terraform
module "vpc" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc"
  vpc_cidr_block             = "172.16.0.0/16"
  public_subnets_cidr_block  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets_cidr_block = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}

module "beanstalk-matriz" {
  source          = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/beanstalk"
  name = "my-beanstalk"
  solution_stack_name = "64bit Amazon Linux 2018.03 v4.14.3 running Node.js"
  settings = [
    { 
      "namespace" = "aws:ec2:vpc", 
      "name" = "VPCId", 
      "value" = module.vpc.vpc_id, 
      "resource" = "" 
    },
    { 
      "namespace" = "aws:ec2:vpc",
      "name" = "Subnets", 
      "value" = join(",", module.vpc.private_subnets), 
      "resource" = "" 
    },
    { 
      "namespace" = "aws:ec2:instances",
      "name" = "InstanceTypes",
      "value" = "t3.medium",
      "resource" = "" 
    },
  ]
  tags_shared = var.tags_shared
}

```

# Argumentos

* `name` - Nome da aplicação, a qual deve ser unica em toda a conta

* `description` - (Opcional) Descrição da aplicação. O valor padrão é ""

* `cname_prefix` - (Opcional) Prefixo a ser utilizado para gerar o DNS do BeanStalk. O valor padrão é ""

* `solution_stack_name` - Stack AWS do ambiente a ser utilizada pela aplicação, podendo ser consultados no seguinte link: [BeanStalk Solutions](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html)

* `tier` - (Opcional) Tipo do LoadBalancer (Worker ou WebServer). O valor padrão é "WebServer"

* `settings` - (Opcional) Lista de Objetos contendo as configurações roteamento ("ouvintes") do LoadBalancer. As opções podem ser encontrados neste link: [BeanStalk General Options](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html). Os objetos devem conter as seguintes informações:

  * `namespace` - Namespace identificando o recurso AWS associado. Ex "aws:ec2:vpc"

  * `name` - Nome da opção de configuração

  * `value` - Valor da configuração

  * `resource` - (Opcional) Nome do recurso para [scheduled action](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingscheduledaction), caso contrário utilize o valor vazio ("")

* `enable_ssm` - (Opcional) Booleano indicando se o módulo deverá criar chaves-valor no SSM para os recursos criados. O valor padrão é true

* `ssm_prefix` - (Opcional) prefixo a ser utilizado a formação da chave SSM. O valor padrão é "eb"

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs


* `arn` - arn da applicação beanstalk

* `ssm_arn` - chave ssm com valor `arn` do beanstalk

* `environment_id` - identificador do ambiente beanstalk

* `cname` - DNS gerado pelo beanstalk

* `ssm_cname` - chave ssm com valor `cname` do beanstalk

* `instances` - lista contendo os ids das EC2 geradas pelo beanstalk

* `autoscaling_groups` - lista contendo os ids dos autoscaling groups utilizados pelo beanstalk

* `load_balancers` - lista contendo os ids dos loadbalancers utilizados pelo beanstalk

* `ssm_load_balancers` - chave ssm com valor `load_balancers` do beanstalk. Caso nenhum loadbalance seja gerado o conteudo (value) do SSM será "not defined"

* `endpoint_url` - URL para o ambiente beanstalk (Loadbalancer DNS ou o IP Fixo da EC2, caso o LoadBalancer não seja criado)

* `ssm_load_balancers` - chave ssm com valor `endpoint_url` do beanstalk.