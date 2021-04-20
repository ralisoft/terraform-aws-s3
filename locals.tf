#--------------------------------------------------------------
# locals - common variables
#--------------------------------------------------------------
locals {
  tags = merge(var.tags, var.s3_public_access ? {} : { "Config" = "s3-bucket-public-read-prohibited" })
}

locals {
  template_dir = "${path.module}/templates"
  template_vars = {
    encrypt               = var.s3_require_encryption_enabled
    bucket_arn            = aws_s3_bucket.bucket.arn
    extra_statements      = var.s3_bucket_policy
    cloudfront_identities = var.s3_cloudfront_identities
  }
  policy      = templatefile("${local.template_dir}/policy.tpl", local.template_vars)
  bucket_name = var.s3_bucket_name != "" ? var.s3_bucket_name : "${var.aws_account}-${var.s3_bucket_prefix}-${var.aws_region}"
}