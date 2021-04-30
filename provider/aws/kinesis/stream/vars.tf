variable "name" { type = "string" }
variable "shard_count" { type = "string" }
variable "retention_period" { default = 24 }

variable "shard_level_metrics" { 
  type = list(string)
  default = [    
    "IncomingBytes",
    "IncomingRecords"
  ]
}

variable "tags_shared" { type = "map" }