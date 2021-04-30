# AWS SQS Module

Este módulo ter por objetivo provisionar o recurso SQS, possibilitando a exportação dos parametros via SSM, além da criação de uma fila de erro com sua respectiva política de *redrive* caso necessário

# Utilização

```terraform
module "sqs" {
  source       = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/sqs"
  sqs_name     = "my-sqs-queue"
}
```

# Argumentos

* `sqs_name` - Nome do fila

* `delay_seconds` - (Opcional) Tempo em segundos que a entrega da mensagem da fila será postergada. Valor interiro de 0 á 900. O padrão é 0 segundos

* `max_message_size` - (Opcional) Limite de quantos bytes uma mensagem pode conter antes que o SQS rejeite ela. Valor inteiro de 1024 (1 KiB) até 262144 bytes (256 KiB). O valor padrão é 262144 (256 KiB)

* `message_retention_seconds` - (Opcional) Tempo máximo em segundos que a fila irá armazenar a mensagem. Valor inteiro de 60 (1 minuto) até 1209600 (14 dias). O valor padrão é 1209600 (14 dias)  

* `receive_wait_time_seconds` - (Opcional) Tempo máximo em segundos que a fila irá permitir um consumidor esperar para receber a mensagem (long polling). Valor inteiro de 0 até 20. O valor padrão é 0

* `visibility_timeout_seconds` - (Opcional) Tempo visibilidade da mensagem. Valor inteiro de 0 até 43200 (12 horas). O valor padrão é 30

* `max_receive_count` - (Opcional) Número máximo de tentativas para processar a mensagem, após isso a mensagem será depositar na fila de erro se houver. O valor padrão é 5

* `create_error_queue` - (Opcional) Booleano indicando se a fila de erro deve ser criada, a fila de erro será o nome do sqs acrescido pelo sufixo `-error`. O valor padrão é true

* `enable_ssm` - (Opcional) Booleano indicando se o módulo deverá criar chaves-valor no SSM para os recursos criados. O valor padrão é true

* `kms_master_key_id` - (Opcional) O ID de uma chave mestra de cliente gerenciada pela AWS (CMK) para Amazon SQS ou um CMK personalizado . O valor padrão é null

* `kms_data_key_reuse_period_seconds` - (Opcional) O período de tempo, em segundos, durante o qual o Amazon SQS pode reutilizar uma chave de dados para criptografar ou descriptografar mensagens antes de chamar o AWS KMS novamente. Um número inteiro que representa os segundos, entre 60 segundos (1 minuto) e 86.400 segundos (24 horas). O padrão é 300 (5 minutos)

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `id` - url da fila

* `url` - url da fila, identico a propriedade `id`

* `arn` - arn da fila

* `ssm_url` - chave ssm com valor `url` da fila

* `ssm_arn` - chave ssm com valor `arn` da fila

* `error_url` - url da fila de erro

* `error_arn` - arn da fila de erro

* `ssm_error_url` - chave ssm com valor `error_url` da fila de erro

* `ssm_error_arn` - chave ssm com valor `error_arn` da fila de erro
