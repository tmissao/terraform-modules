variable "name" {
  description = "The name of the ELB"
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
  default     = null
}

variable "security_groups_ids" {
  description = "A list of security group IDs to assign to the ELB. Only valid if creating an ELB within a VPC"
  default     = []
}

variable "subnets_ids" {
  description = "A list of subnet IDs to attach to the ELB"
}

variable "instances_ids" {
  description = "A list of instance ids to place in the ELB pool"
  default     = []
}

variable "internal" {
  description = "If true, ELB will be an internal ELB"
  default     = false
}

variable "listeners" {
   type = list(object({
    instance_port = number
    instance_protocol = string
    lb_port = number
    lb_protocol  = string
    ssl_certificate_id = string
  }))
  description = "A list of listener blocks"
}

variable "health_check" {
  type = list(object({
    healthy_threshold = number
    unhealthy_threshold = number
    target = string /* ${PROTOCOL}:${PORT}${PATH} */
    interval  = number
    timeout = number
  }))
  description = "A health_check block."
  default     = []
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  default     = true
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  default     = 60
}

variable "connection_draining" {
  description = "Boolean to enable connection draining"
  default     = false
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain"
  default     = 300
}

variable "enable_ssm" { 
  description = "Creates SSM key/value of main resources variables"
  default = true
}

variable "ssm_prefix" {
  description = "Prefix used to create SSM keys"
  default= "elb"
}

variable "tags_shared" { 
  type = map(string) 
  default = {
    "Terraform" = true
  }
}


