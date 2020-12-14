#--------------------------------------------------------------
# S3 Bucket Policy
#--------------------------------------------------------------
resource "aws_s3_bucket_policy" "bucket" {
  count = var.enabled ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": "arn:aws:s3:::${local.s3_bucket_name}/*",
        "Condition": {
          "Bool": {
            "aws:SecureTransport": "false"
          }
        }
      }      
    ]
  }
  EOF
}