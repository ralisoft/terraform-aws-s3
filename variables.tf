##  AWS Variables
variable "aws_region" {
  type = string
}

variable "aws_account" {
  type = string
}

## S3 Variables
variable "s3_bucket_name" {
  type    = string
  default = ""
}

variable "s3_bucket_prefix" {
  type    = string
  default = ""
}

variable "s3_acl" {
  type = string

  default = "private"
}

variable "s3_public_access" {
  type    = bool
  default = false
}

variable "s3_encryption_enabled" {
  type = bool

  default = true
}

variable "s3_require_encryption_enabled" {
  type = bool

  default = false
}

variable "s3_versioning" {
  type = map(any)

  default = {}
}

variable "s3_logging" {
  type = map(any)

  default = {}
}

variable "s3_website" {
  type = map(any)

  default = {}
}

variable "s3_lifecycle_rule" {
  type = list(any)

  default = []
}

## S3 Policy
variable "s3_bucket_policy" {
  type = list(string)

  default = []
}

variable "s3_cloudfront_identities" {
  type = list(string)

  default = []
}

## Misc
variable "tags" {
  type = map(any)

  default = {}
}