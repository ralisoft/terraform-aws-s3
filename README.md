# Amazon S3 Terraform Template

## Configuration

The following table lists the configurable parameters of the terraform template and their default values.

### Variables

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `aws_region`     | AWS Region      | `us-east-1`                                                    |
| `aws_profile` | AWS Profile located in your ~/.aws/credentials  | `live`  |
| `s3_bucket_name` | The name of the bucket | 
| `s3_acl` | The canned ACL to apply. | `private`
| `s3_log_bucket_name` | S3 bucket used to store logs | `exzeo-logs`
| `s3_versioning_enabled` | Enable versioning | `true`
| `s3_lifecycle_enabled` | Whether to enable lifecycle rules | `false`
| `s3_lifecycle_prefix` | S3 Path where to setup lifecycle rule | `/code`
| `s3_lifecycle_ia_days` | How many days until object storage is changed to Infrequently Accessed | `60`
| `s3_lifecycle_glacier_days` | How many days until object storage is changed to Glacier | `120`
| `s3_lifecycle_expiration_days` | How many days until object is removed from S3 | `180`
| `tags` | A mapping of tags to assign to the resource. |

### Tags

A mapping of tags to assign to the resource. This can be any value you want added to the AWS RDS resources.
```
tags {
  foo = "bar"
  action = "test"
}
```

## Example
```
module "s3" {
  source = "git::ssh://git@bitbucket.org/exzeo-dops/tf-s3.git"

  aws_region = "us-east-1"
  aws_profile = "live"  

  s3_bucket_name = "exzeo-react-bits-stage"
  s3_acl    = "public-read"

  s3_lifecycle_enabled = false
}
```

## Outputs
| Parameter               | Description                           | Example                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `id`     | The name of the bucket.      | `bucketname`                                                    |
| `arn` | The ARN of the bucket. | `arn:aws:s3:::bucketname`
| `domain_name` | The bucket domain name. | `bucketname.s3.amazonaws.com`
| `hosted_zone_id | The Route 53 Hosted Zone ID for this bucket's region. | 
| `region` | The AWS region this bucket resides in. | `us-east-1`