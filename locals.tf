#--------------------------------------------------------------
# Local Variables
#--------------------------------------------------------------
locals {
  tags = merge(
    var.tags,
    {
      "ManagedBy"   = data.aws_caller_identity.current.arn
      "Environment" = var.environment
    },
  )

  s3_bucket_name = var.s3_bucket_name == "" ? "${var.s3_bucket_name_prefix}-${var.environment}-${var.aws_region}"  : var.s3_bucket_name

  s3_bucket_policy = <<EOF
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
