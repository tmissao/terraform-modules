# AWS SNS Module

Este módulo ter por objetivo provisionar o recurso SNS, possibilitando a exportação dos parametros via SSM, além de subscrições caso necessário

# Utilização

```terraform
module "core_notify_dump_restore_finished" {
  source                  = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/sns"
  sns_name                = "my-sns"
} 
```

# Argumentos

* `sns_name` - nome do tópico SNS

* `delivery_policy` - (Opcional) política de distruição de mensagem do tópico. O valor padrão é: 
    ```json
    {
      "http": {
        "defaultHealthyRetryPolicy": {
          "minDelayTarget": 20,
          "maxDelayTarget": 20,
          "numRetries": 3,
          "numMaxDelayRetries": 0,
          "numNoDelayRetries": 0,
          "numMinDelayRetries": 0,
          "backoffFunction": "linear"
        },
        "disableSubscriptionOverrides": false
      }
    }
    ```

* `sns_policy` - (Opcional) política AWS para o tópico sns, ela deve seguir a estrutura [IAM Policy documents da AWS](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/access_policies.html). Esta variável substitui a politica padrão oferecida por este módulo, bem como o valor da variável `allowed_accounts`. O valor padrão é null e a política é formada pelo seguinte trecho de códico

   ``` terraform
   data "aws_caller_identity" "current" {}

   data "aws_iam_policy_document" "iam-policy-document" {
     policy_id = "__${var.sns_name}_iam_policy_document_policy_ID"
     statement {
       actions = [
         "SNS:Subscribe",
         "SNS:SetTopicAttributes",
         "SNS:RemovePermission",
         "SNS:Receive",
         "SNS:Publish",
         "SNS:ListSubscriptionsByTopic",
         "SNS:GetTopicAttributes",
         "SNS:DeleteTopic",
         "SNS:AddPermission"
       ]
       condition {
         test = "StringEquals"
         variable = "AWS:SourceOwner"
         values = length(var.allowed_accounts) == 0 ? [data.aws_caller_identity.current.account_id] :    var.allowed_accounts
       }
       effect = "Allow"
       principals {
         type = "AWS"
         identifiers = ["*"]
       }
       resources = [
         "${aws_sns_topic.sns_topic.arn}",
       ]
       sid = "__${var.sns_name}_iam_policy_document_statement_ID"
     }
   }
   ```

* `allowed_accounts` - (Opcional) lista de String contendo os Ids das contas que serão dadas permissões para  poder manipular o SNS, lembrando que a conta que no qual o terraform é executado, já é habilidado por padrão. O valor padrão é []

* `sqs_arns_subscriptions` - (Opcional) Lista de String contendos os Arns dos SQS para fazer a subscrição no tópico usando usando o protocolo "SQS". O valor padrão é [] 

* `endpoints_subscriptions` - (Opcional) Lista de String contendos os endpoins para fazer a subscrição no tópico usando usando o protocolo "HTTPS", o endpoind deve ser a capacidade de aceitar a subscrição de maneira automática. O valor padrão é []

* `sqs_subscription_raw_delivery` - (Opcional) Boleano definindo se para as subscrições do tipo SQS, as mensagens devem ser entregadas da maneira que vieram ao tópico, sem ser serializadas em um JSON. O valor padrão é true

* `endpoint_subscription_raw_delivery` - (Opcional) Boleano definindo se para as subscrições do tipo HTTPS, as mensagens devem ser entregadas da maneira que vieram ao tópico, sem ser serializadas em um JSON. O valor padrão é true

* `enable_ssm` - (Opcional) Booleano indicando se o módulo deverá criar chaves-valor no SSM para os recursos criados. O valor padrão é true

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `name` - nome do tópico sns

* `arn` - arn do tópico sns

* `ssm_arn` - chave ssm com valor `arn` do tópico sns
