resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket
  acl    = var.acl
  policy = var.bucket_policy
  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = cors_rule.value["allowed_headers"]
      allowed_methods = cors_rule.value["allowed_methods"]
      allowed_origins = cors_rule.value["allowed_origins"]
      expose_headers = cors_rule.value["expose_headers"]
      max_age_seconds = cors_rule.value["max_age_seconds"]
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      id         = lifecycle_rule.value["id"]
      prefix     = lifecycle_rule.value["prefix"]
      enabled    = lifecycle_rule.value["enabled"]
      expiration {
        days = lifecycle_rule.value.expiration.days
      }
    }
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes = [tags["data-criacao"]]
  }

  tags   = var.tags_shared 
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id
  block_public_acls   = var.block_public_acls
  block_public_policy = var.block_public_policy
  ignore_public_acls = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}