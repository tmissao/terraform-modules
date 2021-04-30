# AWS Backend Module

Este módulo tem por objetivo provisionar o recurso de Backend de inicialização da infraestrutura da AWS

# Utilização

```terraform
module "backend" {
  source = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/backend"
  aws_region = "aws-region"
  bucket_name = "my-bucket"
  dynamo_table_name = "my-dynamo-table"
}
```

# Argumentos

* `aws_region` - região específica da AWS. O valor padrão é us-east-1

* `bucket_name` - nome do Bucket S3, o nome deve ser exclusivo a nível global

* `dynamo_table_name` - nome da Table do DynamoDB, isso precisa ser exclusivo dentro de uma região AWS

* `tags_shared` - (Opcional) mapa de string, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `StateBucketName` - nome do Bucket

* `DynameLockTableName` - nome da Table