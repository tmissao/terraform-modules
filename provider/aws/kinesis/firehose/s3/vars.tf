variable "name" { type = "string" }
variable "kinesis_stream_arn" { type = "string" }
variable "role_arn" { type = "string" }

variable "bucket_arn" { type = "string" }
variable "buffer_size"     { default = 128 }
variable "buffer_interval" { default = 300 }
variable "compression_format" { default = "UNCOMPRESSED" }

variable "enabled" { default = true }
variable "log_group_name"  { type = "string" }
variable "log_stream_name" { type = "string" }

variable "server_encrypt_enabled" { default = false }

variable "tags_shared" { type = "map" }