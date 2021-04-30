resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [tags["data-criacao"]]
  }

  tags = "${
      merge(
        var.tags_shared,
        map( 
          "Name", "S3 Remote Terraform State Store",
        )
      ) 
  }"
}

resource "aws_s3_bucket_object" "folders" {
    count  = "${length(var.s3_folders)}"
    bucket = "${aws_s3_bucket.s3_bucket.id}"
    key    = "${var.s3_folders[count.index]}/"
    source = "/dev/null"
}

resource "aws_dynamodb_table" "dynamodb" {
  name = "${var.dynamo_table_name}"
  hash_key = "LockID"
  read_capacity  = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags = "${
      merge(
        var.tags_shared,
        map( 
          "Name", "DynamoDB Terraform State Lock Table",
        )
      ) 
  }"
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}