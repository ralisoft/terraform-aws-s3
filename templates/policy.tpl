{
    "Version": "2008-10-17",
    "Statement": [
%{ if encrypt ~}
        {
            "Sid": "DenyIncorrectEncryptionHeader",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "${bucket_arn}/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "AES256"
                }
            }
        },
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "${bucket_arn}/*",
            "Condition": {
                "Null": {
                    "s3:x-amz-server-side-encryption": "true"
                }
            }
        },
%{ endif ~}
        {
            "Sid" : "OnlyAllowSSL",
            "Effect" : "Deny",
            "Principal" : "*",
            "Action" : "s3:*",
            "Resource" : "${bucket_arn}/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }        
%{ if length(extra_statements) > 0 ~}
        },
%{ else ~}
        }
%{ endif ~}

%{for statement in extra_statements ~}
${statement}
%{ endfor ~}
%{for identity in cloudfront_identities ~}
        ,{
            "Effect": "Allow",
            "Principal": {
                "AWS": "${identity}"
            },
            "Action": "s3:GetObject",
            "Resource": "${bucket_arn}/*"    
        }
%{ endfor ~}
    ]
  }