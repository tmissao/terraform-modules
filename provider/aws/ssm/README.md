# AWS SSM Module

Este módulo ter por objetivo provisionar o recurso SSM, armazenando este na forma de chave - valor

# Utilização

```terraform
module "ssm" {
  source  = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/ssm"
  key     = "chave"
  value   = "valor"
}
```

# Argumentos

* `key` - Identificador (Chave) do valor a ser armazenado no SSM

* `prefix` - (Opcional) String que será concatenada antes do valor `key` formando a chave do SSM. O valor padrão é ""

* `sufix` - (Opcional) String que será concatenada depois do valor `key` formando a chave do SSM. O valor padrão é ""

* `value` - Valor da Chave a ser armazenado no SSM

* `type` - (Opcional) Tipo do valor a ser armazenado. Os valores válidos são: `String`, `StringList` e `SecureString`. O valor padrão é String

* `description` - (Opcional) Descrição do SSM . O valor padrão é ""

* `create` - (Opcional) Booleano indicando se o SSM deve ser criado ou não. O valor padrão é true

* `overwrite` - (Opcional) Booleano indicando se o SSM pode ser atualizado ou não. O valor padrão é true

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `parameter_name` - chave do parametro SSM

* `parameter_arn` - arn do parametro SSM

