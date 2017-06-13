#!/usr/bin/env ruby

# RUBY function for decrypting the KMS in conjunction with the s3

require 'aws-sdk'

bucketname = ENV['BUCKET_NAME'] # bucket container the encrypted secret keys
bucket_key = ENV['BUCKET_KEY']  # bucket key 
kms_key_alias = ENV['KMS_KEY_ALIAS']  # Alias of the kms

# S3 client 
s3_client = Aws::S3::Client.new(region: 'your_region')

# KMS client
kms_client = Aws::KMS::Client.new(region: 'your_region')


# retrieve cmk key id
aliases = kms_client.list_aliases.aliases
key = aliases.find { |alias_struct| alias_struct.alias_name == "alias/#{kms_key_alias}" }
key_id = key.target_key_id

# encryption client
s3_encryption_client = Aws::S3::Encryption::Client.new(
    client: s3_client,
    kms_key_id: key_id,
    kms_client: kms_client,
)

# retrieve and decrypt .env from s3
response = s3_encryption_client.get_object(bucket: bucketname, key: bucket_key )

# build string of env vars to be exported.
exports = ""
response.body.read.each_line { |line| exports << "export #{line.chomp};" }

puts exports

