#--------------------------------------------------------------
# S3 Bucket
#--------------------------------------------------------------
resource "aws_s3_bucket" "bucket" {
  count = var.enabled ? 1 : 0

  bucket = var.s3_bucket_name == "" ? "${var.s3_bucket_name_prefix}-${var.environment}-${var.aws_region}"  : var.s3_bucket_name
  acl    = var.s3_acl

  versioning {
    enabled = var.s3_versioning_enabled
  }

  dynamic "logging" {
    for_each = var.s3_logging_enabled ? [1] : []
    content {
      target_bucket = "exzeo-logging-${var.environment}-${var.aws_region}"
      target_prefix = "s3/${var.s3_bucket_name}/"
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.s3_lifecycle_rules
    content {
      id      = lifecycle_rule.value.id
      enabled = lifecycle_rule.value.enabled
      prefix  = lifecycle_rule.value.prefix

      tags = lookup(lifecycle_rule.value, "tags", {})

      expiration {
        days = lifecycle_rule.value.expiration
      }
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(local.tags)
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  count = var.enabled ? 1 : 0

  bucket = element(aws_s3_bucket.bucket.*.id, 0)

  block_public_acls       = var.s3_public_access ? false : true
  block_public_policy     = var.s3_public_access ? false : true
  ignore_public_acls      = var.s3_public_access ? false : true
  restrict_public_buckets = var.s3_public_access ? false : true
}

output "id" {
  value = var.enabled ? aws_s3_bucket.bucket[0].id : ""
}

output "arn" {
  value = var.enabled ? aws_s3_bucket.bucket[0].arn : ""
}

output "domain_name" {
  value = var.enabled ? aws_s3_bucket.bucket[0].bucket_domain_name : ""
}

output "hosted_zone_id" {
  value = var.enabled ? aws_s3_bucket.bucket[0].hosted_zone_id : ""
}

output "region" {
  value = var.enabled ? aws_s3_bucket.bucket[0].region : ""
}