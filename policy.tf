resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  policy = templatefile("${local.template_dir}/policy.tpl", {
    bucket                   = aws_s3_bucket.bucket
    encryption_enabled       = try(var.s3.encryption.enabled, local.s3_defaults.encryption.enabled)
    encryption_required      = try(var.s3.encryption.required, local.s3_defaults.encryption.required)
    encryption_sse_algorithm = try(var.s3.encryption.sse_algorithm, local.s3_defaults.encryption.sse_algorithm)
    extra_statements         = try(var.s3.policy.extra_statements, local.s3_defaults.policy.extra_statements)
    cloudfront_identities    = try(var.s3.cloudfront.identities, local.s3_defaults.cloudfront.identities)
  })

  depends_on = [
    var.s3
  ]
}