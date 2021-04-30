# AWS Certificate Module

Este módulo ter por objetivo provisionar o recurso Certificate

# Utilização

```terraform

module "certificate" {
  source    = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/certificate"
  domain_name = "my-domain.com.br"
  validation_method = "DNS"
}
```

# Argumentos

* `domain_name` - nome de domínio para o qual o certificado deve ser emitido

* `validation_method` - os métodos DNS ou EMAIL são válidos. NENHUM pode ser usado para certificados importados para o ACM e depois para o Terraform. O valor padrão é DNS

* `subject_alternative_names` - (Opcional) uma lista de domínios que devem ser SANs no certificado emitido

* `tags_shared` - (Opcional) mapa de string, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `id` - ID do certificado

* `arn` - ARN do certificado

* `domain_name` - nome do domínio para o qual o certificado é emitido