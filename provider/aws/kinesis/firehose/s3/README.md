# AWS Kinesis Firehose Delivery Stream Module

Este módulo ter por objetivo provisionar o recurso Kinesis Firehose Delivery Stream com fluxos de dados em tempo real e como destino o Extended S3.

# Utilização

```terraform
module "delivery_stream" {
  source    = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/kinesis/firehose/s3"

  name = "my-delivery-stream"
  kinesis_stream_arn = "arn-my-stream"
  role_arn = "arn-role-access-kinesis-stream"

  bucket_arn           = "arn-my-bucket"
  buffer_size          = 128
  buffer_interval      = 300
  compression_format   = "UNCOMPRESSED"

  enabled              = true
  log_group_name       = "log-group-name"
  log_stream_name      = "log-stream-name"
}
```

# Argumentos

* `name` - nome do fluxo do Kinesis Firehose Delivery Stream. É exclusivo da conta e região da AWS em que o Stream é criado.

* `kinesis_stream_arn` - arn do Kinesis Stream.

* `role_arn` - arn da Role que permite acesso ao Kinesis Stream.

* `extended_s3_configuration` suporta os seguintes atributos:

  * `role_arn` - arn da Role
  * `bucket_arn` - arn do S3 Bucket
  * `buffer_size` - (Opcional) Buffer de dados com o tamanho especificado em MBs, antes de entregá-los ao destino. O valor padrão é 5.
  * `buffer_interval` - Buffer para armazenar os dados recebidos pelo período especificado em segundos, antes de entregá-los ao destino. O valor padrão é 300.
  * `compression_format` - O formato de compactação. Se nenhum valor for especificado, o padrão é UNCOMPRESSED. Outros valores suportados são GZIP, ZIP e Snappy.

* `cloudwatch_logging_options` - suporta os seguintes atributos:

  * `enabled` - (Opcional) ativa ou desativa o log. O padrão é `false`.
  * `log_group_name` - (Opcional) nome do grupo CloudWatch para o log. O valor é necessário se `enabled` for `true`.
  * `log_stream_name` - (Opcional) nome do fluxo de log do CloudWatch para log. O valor é necessário se `enabled` for `true`.

* `tags_shared` - (Opcional) mapa de string, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `arn` - arn do Kinesis Firehose Delivery Stream
