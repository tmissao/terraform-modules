# AWS Document DB Module

Este módulo ter por objetivo provisionar o recurso DocumentDB, possibilitando a exportação dos parametros via SSM, e por padrão protegendo seu acesso através de Security Groups específicos

# Utilização

```terraform
module "vpc" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc"
  vpc_cidr_block             = "172.16.0.0/16"
  public_subnets_cidr_block  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets_cidr_block = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}

module "docdb" {
  source = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/docdb"
  docdb_cluster_identifier   = "my-documentdb"
  docdb_username             = "root"
  docdb_password             = "123456ate9"
  vpc_id                     = module.vpc.vpc_id
  private_subnets_ids        = module.vpc.private_subnets
}
```

# Argumentos

* `docdb_cluster_identifier` - nome do cluster DocumentDb

* `docdb_cluster_instances` - (Opcional) número de Instancias no cluster. O valor padrão é 1

* `docdb_cluster_instance_class` - (Opcional) tamanho das instancias no cluster. O valor padrão é "db.r5.large"

* `docdb_engine` - (Opcional) nome do sistema e motor do banco de dados. O valor padrão é  "docdb"

* `docdb_cluster_parameter_group_family` - (Opcional) grupo de parâmetros utilizado pelo engine do cluster. O valor padrão é "docdb3.6"

* `docdb_username` - (Opcional) nome do usuário root do banco de dados. O valor padrão é "root"

* `docdb_password` - (Opcional) senha do usuário root do banco de dados. O valor padrão é "root"

* `docdb_port` - (Opcional) porta em que o banco de dados aceitará conexões. O valor padrão é 27017

* `docdb_backup_retention_period` - (Opcional) número de dias que os backups serão armazenados. O valor padrão é 5

* `docdb_preferred_backup_window` - (Opcional) janela de horário o qual é desejavel realizar o backup diário. O valor padrão é "03:00-04:00"

* `docdb_preferred_maintenance_window` - (Opcional) janela de horário a qual a atualização e manuntenção do cluster será preferimente aplicadas. O valor padrão é "sun:05:00-sun:05:30"

* `allowed_output_ips` - (Opcional) Faixa de Ip para os quais a saída de dados do cluster será liberada. O valor padrão é "0.0.0.0/0"

* `vpc_id` - id da VPC que o Cluster DocumentDb será criado

* `private_subnets_ids` - lista de ids das subnets privadas que o Cluster DocumentDb será criado

* `shared_security_group` - (Opcional) booleano indicando se o tráfego de dados do cluster documentdb para o security group indicado pela variável `allowed_security_group_id` deve ser permitido. O valor padrão é false 

* `allowed_security_group_id` - (Opcional) id da security group no qual o tráfego de dados do cluster documentdb para o security group deve ser liberado. Para essa funcionalidade funcionar a variável `shared_security_group` deve estar habilitada. O valor padrão é null

* `parameters` - (Opcional) lista de objetos representando as configurações de parametros do DocumentDb. As opções podem ser encontradas neste link: [DocumentDB Parameter Groups](https://docs.aws.amazon.com/documentdb/latest/developerguide/cluster_parameter_groups-list_of_parameters.html). Os Objetos devem conter as seguintes propriedades:

  * `name` - Nome do parâmetro

  * `value` - Valor do parâmetro

* `prefix` - (Opcional) prefixo a ser utilizado a formação da chave SSM. O valor padrão é "docdb"

* `enable_ssm` - (Opcional) Booleano indicando se o módulo deverá criar chaves-valor no SSM para os recursos criados. O valor padrão é true

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs


* `arn` - arn do cluster documentdb

* `endpoint` - endpoint de escrita do cluster documentdb

* `ssm_endpoint` - chave ssm com valor `endpoint` do cluster documentdb

* `reader_endpoint` - endpoint de leitura do cluster documentdb

* `ssm_reader_endpoint` - chave ssm com valor `reader_endpoint` do cluster documentdb

* `port` - porta do cluster documentdb

* `ssm_port` - chave ssm com valor `port` do cluster documentdb

* `username` - usuário root do cluster documentdb

* `ssm_username` - chave ssm com valor `username` do cluster documentdb

* `password` - senha do usuário root do cluster documentdb

* `ssm_password` - chave ssm com valor `password` do cluster documentdb

* `sg_client_id` - id do security group habilitado para realizar conexão ao cluster documentdb

* `sg_client_name` - nome do security group habilitado para realizar conexão ao cluster documentdb

* `ssm_sg_client` - chave ssm com valor `sg_client_id` do cluster documentdb

* `sg_docdb_id` - id do security group do cluster documentdb

* `sg_docdb_name` - nome do security group do cluster documentdb
