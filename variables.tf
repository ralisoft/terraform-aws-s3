##  AWS Variables
variable "aws" {
  type = map(any)

  default = {}
}

## S3 Variables
variable "s3" {
  type = map(any)

  default = {}
}

## Misc
variable "tags" {
  type = map(any)

  default = {}
}