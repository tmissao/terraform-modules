output "arn" {
  description = "ARN for the created Certificate"
  value =  "${aws_acm_certificate.certificate.arn}"
}

output "id" {
  description = "ID for the created Certificate"
  value =  "${aws_acm_certificate.certificate.id}"
}

output "domain_name" {
  description = "Domain Name for the created Certificate"
  value =  "${aws_acm_certificate.certificate.domain_name}"
}