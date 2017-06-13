#!/usr/bin/env ruby


# RUBY function for decrypting the KMS in conjunction with the s3

require 'aws-sdk'
require 'json'


config_file = File.read('s3_config.json')
config_hash = JSON.parse(config_file)


kms_keyname = config_hash["KMS_KEYNAME"]
s3_bucketname = config_hash["S3_BUCKETNAME"]
s3_bucket_key = config_hash["S3_BUCKET_KEY"]

# S3 client 
s3_client = Aws::S3::Client.new(region: 'eu-west-1')

# KMS client
kms_client = Aws::KMS::Client.new(region: 'eu-west-1')


# retrieve cmk key id
aliases = kms_client.list_aliases.aliases
key = aliases.find { |alias_struct| alias_struct.alias_name == "alias/#{kms_keyname}" }
key_id = key.target_key_id

# encryption client
s3_encryption_client = Aws::S3::Encryption::Client.new(
    client: s3_client,
    kms_key_id: key_id,
    kms_client: kms_client,
)

# retrieve and decrypt .env from s3
response = s3_encryption_client.get_object(bucket: s3_bucketname, key: s3_bucket_key)

# build string of env vars to be exported.
exports = ""
response.body.read.each_line { |line| exports << "export #{line.chomp};" }

puts exports
