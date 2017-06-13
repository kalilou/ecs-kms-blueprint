# ecs-kms-blueprint

# How it works 

- Create bucket which should contain the docker secrets 
- Create the KMS key in your AWS account 
- Make sure you create a role with a similar policy below which needs to be assigned the task definition or user using the kms key to encrypt the secrets and push to s3 
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "kms:List*",
                "kms:Describe*",
                "kms:Get*",
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:DescribeKey",
                "kms:GenerateDataKey*"
            ],
            "Resource": "your_kms_resource_arn",
            "Effect": "Allow"
        },
        {
            "Action": [
                "kms:ListKeys",
                "kms:ListAliases"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::bucket_container_encrypted_secrets",
                "arn:aws:s3:::bucket_container_encrypted_secrets/*"
            ],
            "Effect": "Allow"
        }
    ]
}
```