
require 'aws-sdk'
require 'json'

# RUBY function for encrypting the KMS in conjunction with the s3

config_file = File.read('s3_config.json')
config_hash = JSON.parse(config_file)


kms_keyname = config_hash["KMS_KEYNAME"]
s3_bucketname = config_hash["S3_BUCKETNAME"]
s3_bucket_key = config_hash["S3_BUCKET_KEY"]




s3_client = Aws::S3::Client.new(region: 'eu-west-1')
s3_resource = Aws::S3::Resource.new(region: 'eu-west-1')


kms_client = Aws::KMS::Client.new(region: 'eu-west-1')


aliases = kms_client.list_aliases.aliases

key = aliases.find { |alias_struct| alias_struct.alias_name == "alias/#{kms_keyname}" }


key_id = key.target_key_id

s3_encryption_client = Aws::S3::Encryption::Client.new(client: s3_client,
                                                       kms_key_id: key_id,
                                                       kms_client: kms_client)


bucket = s3_resource.bucket("#{s3_bucketname}")

if bucket.exists?
    puts "[ Bucket #{bucket} exists already ]"
else
    puts "[ Bucket #{bucket} does not exist, creating it ... ]"
end


path = File.expand_path('environment_vars', __FILE__)


File.open(path) do |file|
  s3_encryption_client.put_object(bucket: "#{s3_bucketname}", key: "#{s3_bucket_key}", body: file)
  puts "[ Done !!!]"
end
