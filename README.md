# ecs-kms-blueprint

# How it works 

- Create bucket which will contain the docker encrypted secrets 
- Create the KMS key in your AWS account and assign the correct policy with the following actions and assign resources which are allow to perform those actions. 
```
[
    "kms:Put*",
    "kms:Get*",
    "kms:List*",
    "kms:Create*",
    "kms:Enable*",
    "kms:Update*",
    "kms:Delete*",
    "kms:Revoke*",
    "kms:Disable*",
    "kms:Describe*",
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:ReEncrypt*",
    "kms:GenerateDataKey*",
    "kms:CancelKeyDeletion",
    "kms:ScheduleKeyDeletion",
    "kms:List*",
    "kms:Describe*",
    "kms:Get*",
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:ReEncrypt*",
    "kms:DescribeKey",
    "kms:GenerateDataKey*"
]
```  
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

# How developer will encrypt and upload to s3 bucket 

- Install awscli  ``` pip install awscli ``` 
- Configure the aws credentials  ``` aws configure ```  (~/.aws/credentials and ~/.aws/config), make sure your user has the policy mentioned above. 
- Install Ruby, for Mac user ``` brew install ruby ```

The folder ``` encryption ``` is where you will encrypt your secrets and upload to s3.
The file ```environment_vars ``` contains the secrets you would like to encrypt.
The file ``` s3_config.json ``` contains s3 bucket and kms key info.

When that is done you can just run ``` ruby s3_kms_encrypt.rb ``` which will encrypt the secrets and upload them to s3 
You can also run ``` ruby s3_kms_decrypt.rb ``` to check your secrets decrypted are the expected value. 


# How to incorporate into the Dockerfile 

- Make sure your container have a role as mentioned above assigned to the task definition 
- In the example folder ```example``` you will have two files decrypt-var.sh and export.sh 
- ```decrypt-var.sh``` will decrypt the secrets and ```export.sh``` will export the decrypted values 



