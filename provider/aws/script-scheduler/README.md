# AWS Script Scheduler

Este módulo ter por objetivo provisionar o agendamento da execução de um script que está armazenado do S3, sendo que para tal é utilizado um evento agendado no CloudWatch que disparará um lambda, o qual iniciará um EC2 que fará o download do script no S3 e executará o próprio, e logo em seguida se desligará.

# Utilização

```terraform

variable "s3_scripts_bucket_name" { default = "kroton-ava30-scripts" }
variable "s3_scripts_path" { default = "/scripts/" }
variable "script_shutdown_name" { default = "documentdb-shutdown.sh" }
variable "ec2_subnet_ids" { default = ["subnet-037e0d86049112c0c"] }
variable "ec2_security_groups_ids" { default = ["sg-03c61e563aa5ab789"] }
variable "schedule_expression_shutdown" { default =  "cron(0 22 ? * 2-5 *)" }

data "aws_iam_policy_document" "ec2_start-stop_docdb" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["${module.s3_scripts.arn}", "${module.s3_scripts.arn}/*" ]
  }
  statement {
    actions = [
      "ec2:TerminateInstances", 
      "tag:GetResources", "tag:GetTagValues", "tag:GetTagKeys",
      "rds:AddTagsToResource", "rds:ListTagsForResource", "rds:RemoveTagsFromResource",
      "rds:DescribeDBInstances", "rds:DescribeDBClusters",
      "rds:StartDBCluster", "rds:StopDBCluster", "rds:StopDBInstance", "rds:StartDBInstance",       
    ]
    resources = ["*"]
  } 
}

module "s3_scripts" {
  source = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/s3"
  bucket = var.s3_scripts_bucket_name
  acl = "private"
}

module "role_ec2_start-stop_docdb" {
  source = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/role"
  name = "Ec2_Allow_To_Start-Stop_DocumentDb"
  principals_identifiers = ["ec2.amazonaws.com"]
  policy = data.aws_iam_policy_document.ec2_start-stop_docdb.json
  create_iam_instance_profile = true
}

resource "aws_s3_bucket_object" "docdb-shutdown" {
  bucket = module.s3_scripts.id
  key    = "${var.s3_scripts_path}${var.script_shutdown_name}"
  source = "../artifacts/documentdb-shutdown.sh" # caminho local do script
  etag = filemd5("../artifacts/documentdb-shutdown.sh") # hash para saber se houve modificações
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

module "script-shutdown-docdb" {
  source = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/script-scheduler"
  name = "shutdown-docdbs"
  ec2_name = "ScriptExecutor-ShutdownDocdb"
  ec2_AMI = data.aws_ami.amazon-linux-2.id
  ec2_subnet_ids = var.ec2_subnet_ids
  ec2_security_group_ids = var.ec2_security_groups_ids
  ec2_role_profile = module.role_ec2_start-stop_docdb.iam_instance_profile_name
  script_bucket_name = module.s3_scripts.id
  script_bucket_file_path = var.s3_scripts_path
  script_bucket_file_name = var.script_shutdown_name
  schedule_expression = var.schedule_expression_shutdown
  tags_shared = var.tags_shared
}


```

# Argumentos

* `name` - nome do evento agendado

* `ec2_name` - nome que será dado a instancia que executará o script

* `ec2_AMI` - imagem que será usada pela EC2

* `ec2_subnet_ids` - subnets ids onde a EC2 será provisionada

* `ec2_security_group_ids` - security groups ids que serão associados a EC2 

* `ec2_role_profile` - nome da iam-role-profile que será associada a EC2

* `script_bucket_name` - nome do bucket no qual o script está armazenado

* `script_bucket_file_path` - caminho relativo para o script dentro do bucket

* `script_bucket_file_name` - nome do script

* `lambda_timeout` - inteiro representando o timeout a ser utilizado pelo lambda. O valor padrão é 180.

* `schedule_expression` - expressão utilizada para realizar o agendamento do evento no cloudwatch, sendo aceitos expressões `cron()` e `rate()`. Para mais informações acesse [link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html)

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `schedule-event-name` - nome do evento agendado