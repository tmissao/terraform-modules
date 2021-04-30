variable "filename" { 
  description = "The path to the function's deployment package within the local filesystem"
  default = null 
}
variable "function_name" {
  description = "A unique name for your Lambda Function"
}
variable "handler" {
  description = "The function entrypoint in your code"
}
variable "role" {
  description = "IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to"
}
variable "description" { 
  description = "Description of what your Lambda Function does"
  default = null
 }
variable "layers" { 
  type = list(string)
  description = " List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function"
  default = []
}
variable "memory_size" { 
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  default = 128
}
variable "runtime" { 
  description = "Lambda Runtime (Java, Node, PHP)"
}
variable "timeout" { 
  description = "The amount of time your Lambda Function has to run in seconds"
  default = 3
}
variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations"
  default = -1
}

variable "vpc_subnet_ids" {
  type = list(string)
  description = "A list of subnet IDs associated with the Lambda function"
  default = []
}

variable "vpc_security_group_ids" {
  type = list(string)
  description = "A list of security group IDs associated with the Lambda function"
  default = []
}

variable "source_code_hash" {
  description = "Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename"
  default = null
}

variable "environment" {
  type = map(string)
  default = {}
}

variable "enable_ssm" { 
  default = true
}

variable "ssm_prefix" {
  default= "lambda"
}

variable "tags_shared" { 
  type = map(string) 
  default = {
    "Terraform" = true
  }
}