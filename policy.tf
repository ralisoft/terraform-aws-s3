#--------------------------------------------------------------
# S3 Bucket Policy
#--------------------------------------------------------------
resource "aws_s3_bucket_policy" "bucket" {
  count = var.enabled && var.s3_bucket_policy != "" ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id

  policy = var.s3_bucket_policy
}