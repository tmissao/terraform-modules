output "arn" {
  description = "The ARN of the ELB"
  value       = aws_elb.loadbalancer.arn
}

output "ssm_arn" {
  description = "SSM key for Resource ARN"
  value       = module.ssm_arn.parameter_name
}

output "name" {
  description = "The Name of the ELB"
  value       = aws_elb.loadbalancer.name
}

output "ssm_name" {
  description = "SSM key for Resource Name"
  value       = module.ssm_name.parameter_name
}

output "dns_name" {
  description = "The DNS name of the ELB"
  value       = aws_elb.loadbalancer.dns_name
}

output "ssm_dns-name" {
  description = "SSM key for Resource DNS Name"
  value       = module.ssm_dns-name.parameter_name
}