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
}
