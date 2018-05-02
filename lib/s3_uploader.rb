#image_helper.rb
require 'aws-sdk-s3'
require 'config_helper'


class S3Uploader 
  include ConfigLoader
	attr_accessor :bucket 
	def initialize(config = nil)
    config =  File.join File.dirname(__FILE__),'config.yml' if config.nil?
		@config = load_config(config)	
    @bucket = @config['buckets']['everything']
    raise "unable to read credentials from config" unless @config['aws_key'] &&@config['aws_secret']
		Aws.config.update({
      region: 'us-west-2',
      credentials: Aws::Credentials.new( @config['aws_key'], @config['aws_secret'])
    })
    @s3 = Aws::S3::Client.new
    begin
      @s3.create_bucket({acl: 'private', bucket: @bucket })
    rescue Exception => e 
      puts "bucket creation failed with #{e.message}"
    end
	end	
	def upload(filepath, key,filename)
      # it's not the responsibility of the uploader to make sure the key is unique 
      unique_key = "#{key}/#{filename}"
      begin
        response = nil 
        File.open(filepath,'rb') do |file|
          response = @s3.put_object(bucket: @bucket, key: unique_key, body: file, acl: 'public-read')
        end
        s3obj = Aws::S3::Object.new(@bucket,unique_key)
        return s3obj.public_url
      rescue Exception => e
        raise "upload failed #{e.message}"
      end
	end
end

