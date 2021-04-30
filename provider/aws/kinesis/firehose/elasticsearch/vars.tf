variable "name" { type = "string" }
variable "kinesis_stream_arn" { type = "string" }
variable "role_arn" { type = "string" }

variable "s3_configuration" {
  type = list(object({
    role_arn = string
    bucket_arn = string
    buffer_size  = number
    buffer_interval = number
    compression_format = string
    cloudwatch_logging_options = object({ 
      enabled = bool 
      log_group_name  = string
      log_stream_name = string
    })  
  }))
  description = "S3 Destination"
  default     = []
}

variable "elasticsearch_configuration" {
  type = list(object({
    domain_arn = string
    role_arn = string
    index_name  = string
    type_name = string
    index_rotation_period = string
    buffering_size = number
    buffering_interval = number
    cloudwatch_logging_options = object({ 
      enabled = bool 
      log_group_name  = string
      log_stream_name = string
    })  
  }))
  description = "Elasticsearch Destination"
  default     = []
}

variable "tags_shared" { type = "map" }