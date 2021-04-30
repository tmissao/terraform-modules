output "arn" {
  description = "The ARN assigned by AWS for this Elastic Beanstalk Application"
  value       = aws_elastic_beanstalk_application.application.arn
}

output "ssm_arn" {
  description = "SSM Key for ARN"
  value =  module.ssm_arn.parameter_name
}

output "environment_id" {
  description = "ID of the Elastic Beanstalk Environment"
  value       = aws_elastic_beanstalk_environment.environment.id
}

output "cname" {
  description = "Fully qualified DNS name for this Environment."
  value       = aws_elastic_beanstalk_environment.environment.cname
}

output "ssm_cname" {
  description = "SSM Key for cname"
  value =  module.ssm_cname.parameter_name
}

output "instances" {
  description = "Instances used by this Environment"
  value       = aws_elastic_beanstalk_environment.environment.instances
}

output "autoscaling_groups" {
  description = "The autoscaling groups used by this Environment"
  value       = aws_elastic_beanstalk_environment.environment.autoscaling_groups
}

output "load_balancers" {
  description = "Elastic load balancers in use by this Environment"
  value       = aws_elastic_beanstalk_environment.environment.load_balancers
}

output "ssm_load_balancers" {
  description = "SSM Key for load_balancers"
  value =  module.ssm_load_balancers.parameter_name
}

output "endpoint_url" {
  description = "The URL to the Load Balancer for this Environment"
  value       = aws_elastic_beanstalk_environment.environment.endpoint_url
}

output "ssm_endpoint_url" {
  description = "SSM Key for endpoint_url"
  value =  module.ssm_endpoint_url.parameter_name
}