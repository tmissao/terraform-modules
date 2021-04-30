module "ssm_s3_arn" {
  source       = "../ssm"
  key          = "arn"
  prefix       = "${var.bucket}-"
  value        = "${aws_s3_bucket.s3_bucket.arn}"
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}

module "ssm_s3_id" {
  source       = "../ssm"
  key          = "id"
  prefix       = "${var.bucket}-"
  value        = "${aws_s3_bucket.s3_bucket.id}"
  create       = var.enable_ssm
  tags_shared  = var.tags_shared
}
