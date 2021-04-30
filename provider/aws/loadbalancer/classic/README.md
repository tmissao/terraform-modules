# AWS Document DB Module

Este módulo ter por objetivo provisionar o recurso Classic LoadBalancer (ELB), exportando seus parametros via SSM

# Utilização

```terraform
module "vpc" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc"
  vpc_cidr_block             = "172.16.0.0/16"
  public_subnets_cidr_block  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets_cidr_block = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}

module "loadbalancer-matriz" {
  source          = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws//loadbalancer/classic"
  name = "my-elb"
  subnets_ids = module.vpc.private_subnets
  listeners = [{ 
    instance_port = 80,
    instance_protocol = "HTTP", 
    lb_port = 80, 
    lb_protocol = "HTTP", 
    ssl_certificate_id = "" 
  }]
  health_check = [{ 
    healthy_threshold = 2, 
    unhealthy_threshold = 2, 
    target = "TCP:80", 
    interval = 30, 
    timeout = 3 
  }]
}
```

# Argumentos

* `name` - (Opcional) nome do LoadBalancer

* `name_prefix` - (Opcional) prefixo de nome para o loadbalancer contendo até 5 caracteres, caso essa variável seja usada a variável `name` não podera ser usada em conjunto

* `security_groups_ids` - (Opcional) Lista de SecurityGroups ids para ser associada ao LoadBalancer

* `subnets_ids` - Lista de Subnets ids do LoadBalancer

* `instances_ids` - (Opcional) Lista de ids de EC2 que receberão tráfego do LoadBalancer

* `internal` - (Opcional) Boolean indicando se o LoadBalancer é interno ou externo. O valor padrão é false

* `listeners` - Lista de Objetos contendo as configurações roteamento ("ouvintes") do LoadBalancer. Os objetos devem conter as seguintes informações:

  * `instance_port` - Porta do Ouvinte

  * `instance_protocol` - Protocolo do Ouvinte

  * `lb_port` - Porta do LoadBalancer

  * `lb_protocol` - Protocolo do LoadBalancer

  * `ssl_certificate_id` - ARN do certificado, caso não existe utilize o valor vazio ("")

* `health_check` - (Opcional) Rota utilizada para verificar se os ouvintes estão ativos. O objeto deve conter as seguintes informações:

  * `healthy_threshold` - Número de tentativas antes que um ouvinte seja considerado ativo

  * `unhealthy_threshold` - Número de tentativas antes que um ouvinte seja considerado desativo

  * `target` - Destino da tentativa, sendo que está deverá seguir o modelo "${PROTOCOLO}:${PORTA}${CAMINHO}"

  * `interval` - Intervalo entre as tentativas

  * `timeout` - Tempo em segundos para que a tentiva se expire

* `cross_zone_load_balancing` - (Opcional) Booleano indicando se o loadbalance deve ser provisionado em mais de uma zona. O valor padrão é true

* `idle_timeout` - (Opcional) Número em segundo que uma conexão pode ficas ociosa. O valor padrão é 60.

* `connection_draining` - (Opcional) Booleano indicando se o loadbalancer irá realizar o "draining" de conexões. O valor padrão é false

* `connection_draining_timeout` - (Opcional) Número em segundo que um ouvinte ficará em processo de "draining". O valor padrão é 300

* `enable_ssm` - (Opcional) Booleano indicando se o módulo deverá criar chaves-valor no SSM para os recursos criados. O valor padrão é true

* `ssm_prefix` - (Opcional) prefixo a ser utilizado a formação da chave SSM. O valor padrão é "elb"

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs


* `arn` - arn do loadbalancer

* `ssm_arn` - chave ssm com valor `arn` do loadbalancer

* `name` - nome do loadbalancer

* `ssm_name` - chave ssm com valor `name` do loadbalancer

* `dns_name` - nome dns do loadbalancer

* `ssm_dns-name` - chave ssm com valor `dns_name` do cluster documentdb