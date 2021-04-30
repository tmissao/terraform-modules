# AWS Bastion (Jump Server) Module

Este módulo ter por objetivo provisionar uma EC2 para possibilitar a conexão e a navegação na VPC

# Utilização

```terraform
module "vpc" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc"
  vpc_cidr_block             = "172.16.0.0/16"
  public_subnets_cidr_block  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets_cidr_block = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}

module "bastion" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/bastion"
  name = "my-bastion"
  vpc_id = module.vpc.vpc_id
  public_subnets_ids = module.vpc.public_subnets
}
```

# Argumentos

* `vpc_id` - id da VPC que o bastion será criado

* `public_subnets_ids` - lista de ids das subnets públicas que o bastion será criado

* `allowed_ips_to_ssh` - (Opcional) Lista de faixas de ips aos quais será aceita a conexão SSH. O valor padrão é ["0.0.0.0/0"]

* `name` - (Opcional) nome do bastion. O valor padrão é "default"

* `instance_type` - (Opcional) tipo da EC2 que o bastion irá utilizar. O valor padrão é "t3.medium"

* `create` - (Opcional) booleano indicando se o bastion deverá ser criado. O valor padrão é true

* `ssh_key_name` - (Opcional) nome da chave ssh. O valor padrão é "bastion-key"

* `ssh_public_key_path` - (Opcional) caminho para a chave pública que será utilizado para o servidor autenticar a conexão SSH. O valor padrão é "/keys/bastion-key.pub"

* `ssh_private_key_path` - (Opcional) caminho para a chave privada utilizada para se conectar ao servidor. O valor padrão é "/keys/bastion-key.pk"

* `allowed_security_group_id` - (Opcional) id do security-group extra a ser utilizado pelo bastion. O valor padrão é null

* `cloudwatch_create_alarm` - (Opcional) booleano indicando se o cloudwatch alarm deverá ser criado. O valor padrão é false

* `cloudwatch_threshold` - (Opcional) valor ao qual a estatística especificada é comparada. O valor padrão é 70

* `cloudwatch_alarm_actions_sns_arn` - (Opcional) lista de ações a serem executadas quando o alarme passar de um estado para outro estado. Cada ação é especificada como um ARN de um SNS . O valor padrão é []

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs


* `public_ip` - IP público do bastion

* `ssh` - comando SSH utilizado para se conectar no bastion