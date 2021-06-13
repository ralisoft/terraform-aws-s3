resource "aws_s3_bucket" "bucket" {
  bucket = try(var.s3.bucket.name, local.s3_defaults.bucket.name)
  acl    = try(var.s3.bucket.acl, local.s3_defaults.bucket.acl)

  dynamic "versioning" {
    for_each = try(var.s3.versioning.enabled, local.s3_defaults.versioning.enabled) ? [1] : []

    content {
      enabled    = try(var.s3.versioning.enabled, local.s3_defaults.versioning.enabled)
      mfa_delete = try(var.s3.versioning.mfa_delete, local.s3_defaults.versioning.mfa_delete)
    }
  }

  dynamic "logging" {
    for_each = try(var.s3.logging.enabled, local.s3_defaults.logging.enabled) ? [1] : []

    content {
      target_bucket = tostring(try(var.s3.logging.target_bucket, local.s3_defaults.logging.target_bucket))
      target_prefix = tostring(try(var.s3.logging.target_prefix, local.s3_defaults.logging.target_prefix))
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = try(var.s3.encryption.enabled, local.s3_defaults.encryption.enabled) ? [1] : []
    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = try(var.s3.encryption.sse_algorithm, local.s3_defaults.encryption.sse_algorithm)
        }
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = toset(keys({ for i, r in try(var.s3.lifecycle, []) : i => r }))

    content {
      id      = try(var.s3.lifecycle.id, null)
      prefix  = var.s3.lifecycle.prefix
      enabled = true

      transition {
        days          = 90
        storage_class = "STANDARD_IA"
      }

      transition {
        days          = 180
        storage_class = "GLACIER"
      }

      expiration {
        days = 360
      }
    }
  }

  tags = merge(local.tags)

  lifecycle {
    ignore_changes = [
      replication_configuration
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = try(var.s3.bucket.public_access, local.s3_defaults.bucket.public_access) ? false : true
  block_public_policy     = try(var.s3.bucket.public_access, local.s3_defaults.bucket.public_access) ? false : true
  ignore_public_acls      = try(var.s3.bucket.public_access, local.s3_defaults.bucket.public_access) ? false : true
  restrict_public_buckets = try(var.s3.bucket.public_access, local.s3_defaults.bucket.public_access) ? false : true

  depends_on = [
    aws_s3_bucket_policy.bucket
  ]
}
