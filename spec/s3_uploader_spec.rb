require 'spec_helper'
require_relative '../lib/s3_uploader'
describe S3Uploader do
 before :each do
 end
 @ignore
 it "can upload a file to the private everything bucket" do
     pending
     s = S3Uploader.new('everything', 'private')
     now = Time.now.to_i
     expected_file_location = "https://your.aws.region.amazonaws.com/super/test/key/#{now}/uploader_field_name"

     uploaded_file_location = s.upload('./spec/uploader/test.png', "super/test/key/#{now}", 'uploader_field_name', 'private')
    
     expect(expected_file_location).to eq(uploaded_file_location)
 end
 @ignore
 it "can upload a file to the public profile image bucket" do
     pending
     s = S3Uploader.new('profile_images', 'public-read')
     now = Time.now.to_i
     expected_file_location = "https://your.aws.bucket.and.region.amazonaws.com/super/test/key/#{now}/uploader_field_name"

     uploaded_file_location = s.upload('./spec/uploader/test.png', "super/test/key/#{now}", 'uploader_field_name','public-read')
    
     expect(expected_file_location).to eq(uploaded_file_location)
     pending
 end
end
