variable "name" {
  description = "The name of the application, must be unique within your account"
}

variable "description" {
  description = "Short description of the application"
  default = null
}

variable "cname_prefix" {
  description = "Prefix to use for the fully qualified DNS name of the Environment"
  default = null
}

variable "solution_stack_name" {
  description = "A solution stack to base your environment off of."
}

variable "tier" {
  description = "Elastic Beanstalk Environment tier. Valid values are Worker or WebServer"
  default = "WebServer"
}

variable "settings" {
   type = list(object({
    namespace = string
    name = string
    value = string
    resource  = string
  }))
  default = []
}
  
variable "enable_ssm" { 
  default = true
}

variable "ssm_prefix" {
  default= "eb"
}

variable "tags_shared" { 
  type = map(string) 
  default = {
    "Terraform" = true
  }
}