# AWS S3 Module

Este módulo ter por objetivo provisionar o recurso S3, possibilitando a exportação dos parametros via SSM, e por padrão bloqueando todos os acesso públicos ao S3

# Utilização

```terraform
module "s3" {
  source = "git@ssh.dev.azure.com:v3/kdop/System%20Team/terraform-modules//provider/aws/s3"
  bucket = "my-bucket"
  acl    = "private"
}
```

# Argumentos

* `bucket` - Nome do Bucket

* `acl` - (Opcional) Lista de Controle de Acesso do Bucket. [Canned ACL](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl). O valor padrão é "private"

* `block_public_acls` - (Opcional) A definição dessa opção como TRUE causa o seguinte comportamento:

    * As chamadas PUT Bucket acl e PUT Object falharão se a Access Control List (ACL – Lista de controle de acesso) especificada for pública.

    * As chamadas PUT Object falharão se a solicitação incluir uma ACL pública.

    * Se essa configuração for aplicada a uma conta, as chamadas PUT Bucket falharão se a solicitação incluir uma ACL pública.

    Quando essa configuração for definida como TRUE, as operações especificadas falharão (sejam feitas por meio da API REST, da AWS CLI ou dos SDKs da AWS). Porém, as políticas e as ACLs existentes para buckets e objetos não são modificadas. Essa configuração permite se proteger contra acesso público ao mesmo tempo em que permite auditar, refinar ou alterar as políticas e as ACLs existentes para os buckets e os objetos

* `block_public_policy` - (Opcional) Definir esta opção como TRUE para um bucket faz com que o Amazon S3 rejeite chamadas para a política PUC Bucket se a política de bucket especificada permitir acesso público e rejeite chamadas para a política PUT Access Point para todos os pontos de acesso do bucket se a política especificada permitir acesso público. Definir esta opção como TRUE para um ponto de acesso faz com que o Amazon S3 rejeite chamadas para a política PUT Access Point e a política PUT Bucket que são feitas por meio do ponto de acesso se a política especificada (para o ponto de acesso ou para o bucket subjacente) for pública. O valor padrão é true

* `ignore_public_acls` - (Opcional) A definição dessa opção como TRUE faz o Amazon S3 ignorar todas as ACLs públicas em um bucket e todos os objetos contidos. Essa configuração permite bloquear com segurança acesso público concedido por ACLs ao mesmo tempo em que permite chamadas PUT Object que incluam uma ACL pública (ao contrário de BlockPublicAcls, que rejeita chamadas PUT Object que incluam uma ACL pública). A habilitação dessa configuração não afeta a persistência de ACLs existentes nem evita a definição de novas ACLs públicas. O valor padrão é true

* `restrict_public_buckets` - (Opcional) A definição dessa opção como TRUE restringe o acesso a um ponto de acesso ou um bucket com uma política pública apenas a serviços da AWS e a usuários autorizados dentro da conta do proprietário do bucket. Essa definição bloqueia todo o acesso entre contas ao ponto de acesso ou ao bucket (exceto por serviços da AWS), ao mesmo tempo que continua permitindo que usuários dentro da conta gerenciem o ponto de acesso ou o bucket. O valor padrão é true.

* `cors_rules` - (Opcional) Lista de objetos representando as regras de CORS a serem aplicadas no bucket. O objeto deve conter as seguintes variáveis:

  * `allowed_headers` - Lista de headers permitidos

  * `allowed_methods` - Lista de métodos permitidos (GET, POST, PUT, DELETE, HEAD)

  * `allowed_origins` - Lista de origens permitidas

  * `expose_headers` - Lista de headers expostos na resposta da requisição

  * `max_age_seconds` - Número de segundos que o browser pode cachear a resposta para um pré requisição (preflight)


* `lifecycle_rules` - (Opcional) Lista de objetos representando as regras do Lifecycle Rules a serem aplicadas no bucket. O objeto deve conter as seguintes variáveis:

  * `id` - Identificador único da regra. Deve ter no máximo a 255 caracteres. 

  * `prefix` - Prefixo da chave do objeto que identifica um ou mais objetos aos quais a regra se aplica.

  * `enabled` - Status da regra do ciclo de vida. O valor padrão é true

  * `expose_headers` - Período de expiração do objeto.

  * `expiration` - Período de expiração do objeto. O valor padrão é days = 7

* `enable_ssm` - (Opcional) Booleano indicando se o módulo deverá criar chaves-valor no SSM para os recursos criados. O valor padrão é true

* `tags_shared` - (Opcional) Mapa de String, chave-valor contendo as tags que serão associadas aos recursos criados

# Outputs

* `id` - nome do bucket

* `arn` - arn do bucket

* `bucket_domain_name` - nome do domínio do bucket. Estará no formado `nome-bucket.s3.amazonaws.com`

* `ssm_s3_id` - chave ssm com valor `id` do bucket

* `ssm_s3_arn` - chave ssm com valor `arn` do bucket
