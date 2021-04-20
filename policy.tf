resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = local.policy

  depends_on = [
    var.s3_cloudfront_identities
  ]
}