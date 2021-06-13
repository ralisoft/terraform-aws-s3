#--------------------------------------------------------------
# locals - common variables
#--------------------------------------------------------------
locals {
  tags = merge(var.tags, {})

  template_dir = "${path.module}/templates"

  aws_defaults = {
    region : "us-east-1"
  }

  s3_defaults = {
    bucket : {
      name : "${var.aws.account}-${var.s3.bucket.prefix}-${try(var.aws.region, local.aws_defaults.region)}"
      acl : "private"
      public_access : false
    }

    versioning : {
      enabled : false
      mfa_delete : false
    }

    logging : {
      enabled : false
      target_bucket : ""
      target_prefix : "s3/${try(var.s3.bucket.name, "${var.aws.account}-${var.s3.bucket.prefix}-${try(var.aws.region, local.aws_defaults.region)}")}"
    }

    encryption : {
      enabled : true
      required : true
      sse_algorithm : "AES256"
    }

    cloudfront : {
      identities : []
    }

    policy : {
      extra_statements : []
    }

  }
}