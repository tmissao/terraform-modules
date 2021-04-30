# AWS VPC Peering Module

Este módulo ter por objetivo provisionar o pareamento entre VPCs

# Utilização

```terraform

// Requester VPC
module "vpc1" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc-1"
  vpc_cidr_block             = "172.16.0.0/16"
  public_subnets_cidr_block  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets_cidr_block = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}

// Accepter VPC
module "vpc2" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpc"
  vpc_name                   = "my-vpc-2"
  vpc_cidr_block             = "10.0.0.0/16"
  public_subnets_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets_cidr_block = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

module "vpc_peering" {
  source = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/vpcpeering"
  vpc_peering_name = "my-vpc-peering"
  peer_access_key =  "access_key_of_accepter_vpc"
  peer_secret_key =  "secret_key_of_accepter_vpc"
  aws_peer_region =  "region_of_accepter_vpc"
  vpc_requester_id = module.vpc1.vpc_id
  vpc_accepter_id =  module.vpc2.vpc_id
  peering_allow_dns_resolution =  true
  create_peering_public_route_on_requester_vpc = true
  create_peering_private_route_on_requester_vpc = true
  requester_vpc_public_route = module.vpc1.public_routing_table_id
  requester_vpc_private_route = module.vpc1.private_routing_table_id
  create_peering_public_route_on_accepter_vpc = true
  create_peering_private_route_on_accepter_vpc = true
  accepter_vpc_public_route = module.vpc2.public_routing_table_id
  accepter_vpc_private_route = module.vpc2.public_routing_table_id
}
```

# Argumentos

* `vpc_peering_name` - nome da VPC Peering

* `peer_access_key` - chave de acesso da conta AWS da VPC Accepter

* `peer_secret_key` - segredo da chave de acesso da conta AWS da VPC Accepter

* `aws_peer_region` - região da VPC Accepter

* `vpc_requester_id` - id da VPC Requester que irá pedir o peering

* `vpc_accepter_id` - id da VPC Accpeter que irá aceitar o peering

* `peering_allow_dns_resolution` - (Opcional) booleando habilitando a resolução de dns entre as VPCs. O valor padrão é false

* `create_peering_public_route_on_requester_vpc` - (Opcional) booleando indicando se deverá ser criado a rota na tabela de roteamento das subnets públicas da VPC requester para a VPC accepter. O valor padrão é false

* `create_peering_private_route_on_requester_vpc` - (Opcional) booleando indicando se deverá ser criado a rota na tabela de roteamento das subnets privadas da VPC requester para a VPC accepter. O valor padrão é false

* `requester_vpc_public_route` - (Opcional) id da tabela de roteamento das subnets públicas da VPC Requester para criação da rota para a VPC Accepter, caso a variável `create_peering_public_route_on_requester_vpc` esteja ativada. O valor padrão é null

* `requester_vpc_private_route` - (Opcional) id da tabela de roteamento das subnets privadas da VPC Requester para criação da rota para a VPC Accepter, caso a variável `create_peering_private_route_on_requester_vpc` esteja ativada. O valor padrão é null
--

* `create_peering_public_route_on_accepter_vpc` - (Opcional) booleando indicando se deverá ser criado a rota na tabela de roteamento das subnets públicas da VPC accepter para a VPC requester. O valor padrão é false

* `create_peering_private_route_on_accepter_vpc` - (Opcional) booleando indicando se deverá ser criado a rota na tabela de roteamento das subnets privadas da VPC accepter para a VPC requester. O valor padrão é false

* `accepter_vpc_public_route` - (Opcional) id da tabela de roteamento das subnets públicas da VPC Accepter para criação da rota para a VPC Requester, caso a variável `create_peering_public_route_on_accepter_vpc` esteja ativada. O valor padrão é null

* `accepter_vpc_private_route` - (Opcional) id da tabela de roteamento das subnets privadas da VPC Accpeter para criação da rota para a VPC Requester, caso a variável `create_peering_private_route_on_accepter_vpc` esteja ativada. O valor padrão é null

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `peering_id` - id da vpc peering