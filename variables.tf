# --------------------------------------------------------------
#  AWS
# --------------------------------------------------------------
variable "aws_region" {
  type = string

  default = "us-east-1"
}

# --------------------------------------------------------------
#  S3
# --------------------------------------------------------------
variable "s3_bucket_name" {
  type = string

  default = ""
}

variable "s3_bucket_name_prefix" {
  type = string

  default = ""
}

variable "s3_acl" {
  type = string

  default = "private"
}

variable "s3_versioning_enabled" {
  type = bool

  default = true
}

variable "s3_logging_enabled" {
  type = bool

  default = true
}

variable "s3_logging_bucket_name" {
  type        = string

  default = ""
}

variable "s3_public_access" {
  type    = bool
  default = false
}

variable "s3_bucket_policy" {
  type = list(any)

  default = []
}

variable "s3_lifecycle_rules" {
  type    = list
  default = []
}

# --------------------------------------------------------------
#  Misc
# --------------------------------------------------------------
variable "tags" {
  type = map

  default = {}
}

variable "environment" {
  type = string
}

variable "enabled" {
  type = bool

  default = true
}