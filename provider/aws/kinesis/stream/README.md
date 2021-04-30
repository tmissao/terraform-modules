# AWS Kinesis Stream Module

Este módulo ter por objetivo provisionar o recurso Kinesis Stream para o processamento em tempo real de streaming de big data.

# Utilização

```terraform
module "stream" {
  source    = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/kinesis/stream"

  name = "my-stream"
  shard_count = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes"
  ]
}
```

# Argumentos

* `name` - nome do Kinesis Stream. É exclusivo da conta e região da AWS em que o Stream é criado.

* `shard_count` - número de Shards que vão ser usados pelo Stream.

* `retention_period` - (Opcional) período de tempo que os registros de dados ficam acessíveis após serem adicionados ao Stream. O valor máximo do período de retenção de um stream é 168 horas. O valor mínimo é 24. O valor padrão é 24.

* `shard_level_metrics` - (Opcional) lista de métricas do CloudWatch para o Stream. [Consulte Monitoring with CloudWatch ](https://docs.aws.amazon.com/streams/latest/dev/monitoring-with-cloudwatch.html). O valor padrão é [
    "IncomingBytes",
    "OutgoingBytes"
  ] 

* `tags_shared` - (Opcional) mapa de string, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `id` - id do Stream

* `arn` - arn do Stream

* `name` - nome do Stream 

* `shard_count` - contador de Shards do Stream 