resource "aws_acm_certificate" "certificate" {
  domain_name                =  "${var.domain_name}"
  validation_method          =  "${var.validation_method}"
  subject_alternative_names  =  var.subject_alternative_names

  tags                       =  var.tags_shared

  lifecycle {
    create_before_destroy = true
    ignore_changes = [tags["data-criacao"]]
  }
}
