provider "aws" {
  region  = try(var.aws.region, local.aws_defaults.region)
  profile = "default"
}