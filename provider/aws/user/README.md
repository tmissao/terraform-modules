# AWS User Module

Este módulo ter por objetivo provisionar a criação de um usuário AWS, juntamente com suas políticas de acesso e chaves

# Utilização

```terraform

data "aws_iam_policy_document" "user-permissions" {
  statement {
    actions = ["s3:*", "sqs:*", "sns:*"]
    resources = ["*"]
  }
}

module "user" {
  source             = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/user"
  user_name          = "my-user"
  user_policy        = data.aws_iam_policy_document.user-permissions.json
}
```

# Argumentos

* `user_name` - nome do usuário

* `user_policy` - política a ser associada ao usuário, sendo que e ela deve seguir a estrutura [IAM Policy documents da AWS](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/access_policies.html)

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `name` - nome do usuário

* `arn` - arn do usuário

* `access_key` - chave de acesso do usuário

* `secret_key` - segredo da chave de acesso do usuário