output "StateBucketName" {
  value = "${aws_s3_bucket.s3_bucket.id}"
}

output "DynameLockTableName" {
  value = "${aws_dynamodb_table.dynamodb.id}"
}