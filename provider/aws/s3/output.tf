output "arn" {
  description = "ARN for the created S3"
  value =  "${aws_s3_bucket.s3_bucket.arn}"
}

output "id" {
  description = "ID for the created S3"
  value =  "${aws_s3_bucket.s3_bucket.id}"
}

output "bucket_domain_name" {
  description = "Bucket Domain Name for the created S3"
  value =  "${aws_s3_bucket.s3_bucket.bucket_domain_name}"
}

output "ssm_s3_arn" {
  description = "SSM Key from S3 ARN"
  value =  "${module.ssm_s3_arn.parameter_name}"
}

output "ssm_s3_id" {
  description = "SSM Key from S3 ID"
  value =  "${module.ssm_s3_id.parameter_name}"
}

output "bucket_arn" {
  description = "Bucket ARN for the created S3"
  value = "${aws_s3_bucket.s3_bucket.arn}"
}

output "bucket_id" {
  description = "Bucket Id for the created S3"
  value = "${aws_s3_bucket.s3_bucket.id}"
}
