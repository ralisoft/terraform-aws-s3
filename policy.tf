#--------------------------------------------------------------
# S3 Bucket Policy
#--------------------------------------------------------------
resource "aws_s3_bucket_policy" "bucket" {
  count = var.enabled && var.s3_bucket_policy != "" ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id

  dynamic "policy" {
    for_each = var.s3_bucket_policy
    content {

    }
  }

  policy = var.s3_bucket_policy
}

# resource "aws_s3_bucket_policy" "public" {
#   count = var.enabled && var.s3_public_access ? 1 : 0

#   bucket = aws_s3_bucket.bucket[0].id

  

#   policy = <<EOF
# {
#     "Version": "2008-10-17",
#     "Statement": [
#       {
#         "Sid" : "PublicRead",
#         "Effect" : "Allow",
#         "Principal" : "*",
#         "Action" : "s3:GetObject",
#         "Resource" : [
#           "arn:aws:s3:::${aws_s3_bucket.bucket[0].id}",
#           "arn:aws:s3:::${aws_s3_bucket.bucket[0].id}/*"
#         ]
#       }
#     ]
#   }
#   EOF
# }

# resource "aws_s3_bucket_policy" "ssl" {
#   count = var.enabled ? 1 : 0

#   bucket = aws_s3_bucket.bucket[0].id

#   policy = <<EOF
# {
#     "Version": "2008-10-17",
#     "Statement": [
#       {
#         "Sid" : "OnlyAllowSSL",
#         "Effect" : "Deny",
#         "Principal" : "*",
#         "Action" : "s3:*",
#         "Resource" : "arn:aws:s3:::${aws_s3_bucket.bucket[0].id}/*",
#         "Condition": {
#             "Bool": {
#                 "aws:SecureTransport": "false"
#             }
#         }        
#       }
#     ]
#   }
# EOF
# }