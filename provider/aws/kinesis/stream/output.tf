output "id" {
  description = "ID for the created Stream"
  value =  "${aws_kinesis_stream.default.id}"
}

output "name" {
  description = "Name for the created Stream"
  value =  "${aws_kinesis_stream.default.name}"
}

output "shard_count" {
  description = "Shard Count for the created Stream"
  value =  "${aws_kinesis_stream.default.shard_count}"
}

output "arn" {
  description = "ARN for the created Stream"
  value =  "${aws_kinesis_stream.default.arn}"
}