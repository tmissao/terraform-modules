# Terraform Modules

Este repositório tem por objetivo armazenar os principais módulos já desenvolvidos pelo terraform, promovendo assim o rápido provisionamento e configuração de ambiente, seguindo as melhores práticas e recomendações

# Instalação

## 1. Terraform
Para utilização dos módulos é necessário primeiramente a Instalação do Terraform

```bash
curl https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip -o ./terraform.zip
unzip terraform.zip
sudo mv terraform /usr/local/bin/
```

A verificação da instalação do Terraform pode ser realizada através do comando:

```bash
terraform -v
# Output: Terraform v0.12.13
```

## 2. Azure Devops chave SSH 

A utilização dos módulos desse repositório se dá através da referência dos mesmos utilizando o Git, como demonstrado na própria documentação do [Terraform](https://www.terraform.io/docs/modules/sources.html#generic-git-repository). Portanto é necessário gerar uma chave de autenticação SSH com o Azure Devops, a fim de permitir que o terraform localize o módulo desejado.

Para gerar sua chave SSH siga os passos listados na documentação do [Azure Devops](https://docs.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate?view=azure-devops&tabs=current-page)

Após isso, basta referenciar o módulo desejado através de seu caminho relativo no repositório usando o recurso de sub-diretórios, de acordo com a própria [documentação](https://www.terraform.io/docs/modules/sources.html#modules-in-package-sub-directories)

# Exemplo de Utilização

```terraform

variable "eks_cluster_identifier" { default = "my-eks" }
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" { default = "us-east-1" }

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

data "aws_iam_policy_document" "devops-permissions" {
  statement {
    actions = ["eks:*"]
    resources = ["*"]
  }
}

module "user_devops" {
  source                     = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/user"
  user_name                  = "devops"
  user_policy                = data.aws_iam_policy_document.devops-permissions.json
}

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
  eks_manager_user_arn       = module.user_devops.arn
  eks_manager_user_name      = module.user_devops.name
  aws_access_key             = var.aws_access_key
  aws_secret_key             =  var.aws_secret_key
  aws_region                 = var.aws_region
}

```

Feito isso ao executar o comando `terraform init` o módulo desejado será carregado! 

# Happy Coding !! =)