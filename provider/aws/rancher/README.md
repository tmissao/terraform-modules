# Rancher

Este módulo ter por objetivo provisionar o [Rancher](https://rancher.com/) Server na AWS.

# Utilização

```terraform
module "vpc" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc"
  vpc_cidr_block             = "172.18.0.0/16"
  public_subnets_cidr_block  = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24"]
  private_subnets_cidr_block = ["172.18.4.0/24", "172.18.5.0/24", "172.18.6.0/24"]
}

module "rancher" {
  source = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws//rancher"
  public_subnets_ids = module.vpc.public_subnets
  ssh_key_name = "rancher"
  rancher_hostname_domain = "rancher.avadigital.com.br"
}
```

# Argumentos

* `public_subnets_ids` - Lista de subnets públicas, onde o rancher server será provisionado

* `ssh_allowed_ips` - (Opcional) Lista de Ips que podem se comunicar com o Rancher usando a porta 22. Valor padrão é ["0.0.0.0/0"].

* `ssh_create_key` - (Opcional) Booleando indicando se uma nova chave SSH será criada. O valor padrão é true.

* `ssh_public_key` - (Opcional) Valor da chave SSH pública a ser criada. Caso nenhum valor seja fornecido a [chave pública](../keys/key.pem) será utilizada. O valor padrão é null.   

* `ssh_key_name` - Nome da chave SSH a ser criada caso o valor da variavél `ssh_create_key`, ou o nome da chave SSH (KeyPair) pré-existente na AWS que será associada ao rancher-server. 

* `instance_size` - (Opcional) Tamanho da instância a ser utilizada pelo Rancher Server. O valor padrão é "t3.medium"

* `rancher_ebs_size_gb` - (Opcional) Tamanho do EBS que será associado ao Rancher Server. O valor padrão é 20.

* `rancher_ebs_device_name` - (Opcional) Nome do Device EBS que será associado a instância. O valor padrão é "/dev/sdf"

* `rancher_ebs_mount_point` - (Opcional) Ponto/Caminho onde o EBS será montado na instância. O valor padrão é "/data"

* `rancher_hostname_domain` - Endereço DNS que o rancher utilizará. Ex: rancher.avadigital.com.br

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `public_ip` - IP Fixo (Elastic IP) do servidor Rancher
