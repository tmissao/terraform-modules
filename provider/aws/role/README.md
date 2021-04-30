# AWS Role Module

Este módulo ter por objetivo provisionar o recurso IAM Role, possibilitando a exportação dos parametros via SSM

# Utilização

```terraform
data "aws_iam_policy_document" "permissions" {
  statement {
    actions = ["s3:*", "sqs:*", "sns:*"]
    resources = ["*"]
  }
}

module "role" {
  source                 = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/role"
  name = "Lambda-Allow-To-Read-Write-S3-SNS-SQS"
  principals_type = "Service"
  principals_identifiers = ["lambda.amazonaws.com"]
  policy = data.aws_iam_policy_document.permissions.json
}
```

# Argumentos

* `name` - nome que será usado para a criação do Role e Policy na AWS

* `create_policy` - (Opcional) Booleano indicando se a Policy deve ser criada para o Role. O valor padrão é false

* `policy` - (Opcional) política AWS que será utilizado pelo Role, ela deve seguir a estrutura [IAM Policy documents da AWS](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/access_policies.html). O valor padrão é null

* `description` - (Opcional) descrição da Role. O valor padrão é ""

* `principals_type` - (Opcional) Tipo do Principal que poderá utilizar a Role. O valor padrão é "Service"

* `principals_identifiers` - (Opcional) Lista de String contendo os identificadores que poderão assumir o Role, eles deverão ser compatíveis com a variável `principals_type`. Ex: `["lambda.amazonaws.com", "ec2.amazonaws.com", "rds.amazonaws.com"]`

* `actions` - (Opcional) Lista de String, representando as ações associadas ao Role. O valor padrão é ["sts:AssumeRole"]

* `force_detach_policies` - (Opcional) Booleano indicando se o terraform deverá forçar a desassociação da política antes de destruir a role. O valor padrão é true

* `create_iam_instance_profile` - (Opcional) Booleano indicando a criação de um IAM Instance Profile para o Role a ser criado. O valor padrão é false

* `enable_ssm` - (Opcional) Booleano indicando se o módulo deverá criar chaves-valor no SSM para os recursos criados. O valor padrão é true

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `name` - nome da role

* `arn` - arn da role

* `ssm_arn` - chave ssm com valor `arn` da role

* `iam_instance_profile_arn` - arn do IAM Instance Profile. Caso o IAM instance Profile não seja criado o valor será 'undefined'

* `ssm_iam_instance_profile_arn` - chave ssm com valor `iam_instance_profile_arn` da IAM Instance Profile

* `iam_instance_profile_name` - nome do IAM Instance Profile. Caso o IAM instance Profile não seja criado o valor será 'undefined'

* `ssm_iam_instance_profile_name` - chave ssm com valor `ssm_iam_instance_profile_name` da IAM Instance Profile