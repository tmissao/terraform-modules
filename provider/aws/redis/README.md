# AWS Redis DB Module

Este módulo ter por objetivo provisionar o recurso Redis, possibilitando a exportação dos parametros via SSM, e por padrão protegendo seu acesso através de Security Groups específicos

# Utilização

```terraform
module "vpc" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc"
  vpc_cidr_block             = "172.16.0.0/16"
  public_subnets_cidr_block  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets_cidr_block = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}

module "redis" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/redis"
  cluster_id                 = "my-redis"
  availability_zones         = "${module.vpc.private_subnets_availability_zone}"
  vpc_id                     = "${module.vpc.vpc_id}"
  private_subnets_ids        = "${module.vpc.private_subnets}"
}
```

# Argumentos

* `cluster_id` - nome único para o cluster Redis

* `description` - (Opcional) descrição do cluster Redis. O valor padrão é "-"

* `engine` - (Opcional) nome do sistema e motor do banco de dados. O valor padrão é  "redis"

* `engine_version` - (Opcional) versão utilizada pelo engine do cluster, o valor deve ser compatível com a variável `engine`. O valor padrão é "5.0.5"

* `parameter_group_name` - (Opcional) grupo de parâmetros a ser utilizado pelo engine do cluster, o valor deve ser compatível com a variável `engine`. O valor padrão é "default.redis5.0"

* `port` - (Opcional) porta em que o Redis aceitará conexões. O valor padrão é 6379

* `node_type` - (Opcional) tamanho da máquina a ser utilizado pelo cluster Redis. O valor padrão é "cache.t2.medium"

* `number_cache_clusters` - (Opcional) tNúmero de instancias do cluster Redis, esse número deve ser pelo menos 2. O valor padrão é 2

* `snapshot_retention_limit` - (Opcional) número de dias que os backups serão armazenados. O valor padrão é 5

* `snapshot_window` - (Opcional) janela de horário o qual é desejavel realizar o backup diário. O valor padrão é "00:00-05:00"

* `allowed_output_ips` - (Opcional) Faixa de Ip para os quais a saída e entrada de dados do cluster será liberada. O valor padrão é "0.0.0.0/0"

* `vpc_id` - id da VPC que o Cluster Redis será criado

* `availability_zones` - lista de Availability Zones as quais o cluster Redis será utilizado, o valor dessa lista deve refletir as zonas das subnets privadas representado pela variável `private_subnets_ids`

* `private_subnets_ids` - lista de ids das subnets privadas que o Cluster Redis será criado

* `allowed_security_group_id` - (Opcional) id da security group no qual o tráfego de dados do cluster redis para o security group deve ser liberado. O valor padrão é null

* `enable_ssm` - (Opcional) Booleano indicando se o módulo deverá criar chaves-valor no SSM para os recursos criados. O valor padrão é true

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs


* `primary_endpoint` - endpoint primário do cluster redis

* `port` - porta do cluster redis

* `sg_client_id` -  id do security group habilitado para realizar conexão ao cluster documentdb

* `ssm_sg_client_id` - chave ssm com valor sg_client_id do cluster documentdb

