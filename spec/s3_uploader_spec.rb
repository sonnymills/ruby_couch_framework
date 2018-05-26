require 'spec_helper'
require_relative '../lib/s3_uploader'
describe S3Uploader do
 before :each do
 end
 it "can upload a file to the private everything bucket" do
     s = S3Uploader.new('everything', 'private')
     now = Time.now.to_i
     expected_file_location = "https://dev-c360.s3.us-west-2.amazonaws.com/super/test/key/#{now}/uploader_field_name"

     uploaded_file_location = s.upload('./spec/uploader/test.png', "super/test/key/#{now}", 'uploader_field_name', 'private')
    
     puts "Uploaded URL: #{uploaded_file_location}"     
     expect(expected_file_location).to eq(uploaded_file_location)
 end
 it "can upload a file to the public profile image bucket" do
     s = S3Uploader.new('profile_images', 'public-read')
     now = Time.now.to_i
     expected_file_location = "https://dev-c360-profile-images.s3.us-west-2.amazonaws.com/super/test/key/#{now}/uploader_field_name"

     uploaded_file_location = s.upload('./spec/uploader/test.png', "super/test/key/#{now}", 'uploader_field_name','public-read')
    
     puts "Uploaded URL: #{uploaded_file_location}"     
     expect(expected_file_location).to eq(uploaded_file_location)
 end
end
