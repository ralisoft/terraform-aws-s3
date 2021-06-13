{
    "Version": "2008-10-17",
    "Statement": [
%{ if encryption_required && encryption_enabled ~}
        {
            "Sid": "DenyIncorrectEncryptionHeader",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "${bucket.arn}/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "${encryption_sse_algorithm}"
                }
            }
        },
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "${bucket.arn}/*",
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
            "Resource" : "${bucket.arn}/*",
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
            "Resource": "${bucket.arn}/*"    
        }
%{ endfor ~}
    ]
  }