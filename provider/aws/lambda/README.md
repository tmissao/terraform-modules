# AWS Lambda

Este módulo ter por objetivo provisionar o recurso Lambda), exportando seus parametros via SSM

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

module "lambda" {
  source          = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/lambda"
  filename = "./src/my-lambda-source.zip"
  function_name = "my-lambda"
  handler = "index.handler"
  role = module.role.arn
  runtime = "nodejs10.x"
}
```

# Argumentos

* `filename` - (Opcional) Caminho do arquivo com o código compactado do lambda. O valor padrão é null

* `function_name` - Nome do lambda, este deve ser único na conta AWS

* `handler` - Ponto de entrada do código do lambda

* `role` - Role com as permissões do lambda

* `description` - (Opcional) Descrição da função lambda. O valor padrão é null

* `layers` - (Opcional) Lista com os Arns dos lambda layers a serem utilizados pelo lambda. O valor padrão é []

* `memory_size` - (Opcional) Quantidade de memória utilizada pelo lambda. O valor padrão é 128

* `runtime` - Contexto de execução do lambda (Node, Java, Php). Os valores disponíveis podem ser encontrados em [lambda-runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)

* `timeout` - (Opcional) Tempo máximo em segundos da execução do lambda. O valor padrão é 3

* `reserved_concurrent_executions` - (Opcional) Limite de execuções paralelas. O valor 0 desabilita a execução do lambda e o valor -1 remove as limitações. O valor padrão é -1

* `vpc_subnet_ids` - (Opcional) Lista de ids das subnets onde o lambda será executado. O valor padrão é []. Caso essa variavel não seja vazia será necessário preencher também a variavel `vpc_security_group_ids`

* `vpc_security_group_ids` - (Opcional) Lista de ids das security groups que será associadas ao lambda. O valor padrão é []. Caso essa variavel não seja vazia será necessário preencher também a variavel `vpc_subnet_ids`

* `source_code_hash` - (Opcional) Código Hash utilizado para saber se será necessário atualizar o lambda caso o código do lambda sofra alterações. O valor padrão é null

* `environment` - (Opcional) Dicionário/Mapa chave valor representando as variáveis de ambiente do lambda. O valor padrão é {}

* `enable_ssm` - (Opcional) Booleano indicando se o módulo deverá criar chaves-valor no SSM para os recursos criados. O valor padrão é true

* `ssm_prefix` - (Opcional) prefixo a ser utilizado a formação da chave SSM. O valor padrão é "lambda"

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs


* `arn` - arn do lambda

* `ssm_arn` - chave ssm com valor `arn` do lambda

* `invoke_arn` - arn pelo qual o lambda pode ser executado

* `ssm_invoke_arn` - chave ssm com valor `invoke_arn` do lambda