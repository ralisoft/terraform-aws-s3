resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
  acl    = var.s3_public_access ? "public-read" : var.s3_acl

  dynamic "versioning" {
    for_each = try(var.s3_versioning.enabled, true) ? [1] : []

    content {
      enabled    = try(var.s3_versioning.enabled, true)
      mfa_delete = try(var.s3_versioning.mfa_delete, false)
    }
  }

  dynamic "logging" {
    for_each = try(var.s3_logging.enabled, true) ? [1] : []

    content {
      target_bucket = tostring(try(var.s3_logging.target_bucket, "${var.aws_account}-logging-${var.aws_region}"))
      target_prefix = tostring(try(var.s3_logging.target_prefix, "s3/${local.bucket_name}/"))
    }
  }

  dynamic "website" {
    for_each = length(keys(var.s3_website)) > 0 ? [1] : []
    content {
      index_document           = var.s3_website.index_document
      error_document           = tostring(try(var.s3_website.error_document, null))
      redirect_all_requests_to = tostring(try(var.s3_website.redirect_all_requests_to, null))
      routing_rules            = tostring(try(var.s3_website.routing_rules, null))
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.s3_encryption_enabled ? [1] : []
    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = toset(keys({ for i, r in var.s3_lifecycle_rule : i => r }))

    content {
      id      = try(var.s3_lifecycle_rule[lifecycle_rule.value]["id"], null)
      prefix  = var.s3_lifecycle_rule[lifecycle_rule.value]["prefix"]
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

  block_public_acls       = var.s3_public_access ? false : true
  block_public_policy     = var.s3_public_access ? false : true
  ignore_public_acls      = var.s3_public_access ? false : true
  restrict_public_buckets = var.s3_public_access ? false : true

  depends_on = [
    aws_s3_bucket_policy.bucket
  ]
}
