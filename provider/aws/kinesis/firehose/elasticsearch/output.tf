output "arn" {
  description = "ARN for the created Firehose Delivery Stream"
  value =  "${aws_kinesis_firehose_delivery_stream.elasticsearch.arn}"
}