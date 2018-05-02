require 'spec_helper'
require_relative '../lib/s3_uploader'
describe S3Uploader do
 before :each do
   @s = S3Uploader.new
 end
 it "can upload a file" do
     now = Time.now.to_i
     expected_file_location = "https://dev-c360.s3.us-west-2.amazonaws.com/super/test/key/#{now}/uploader_field_name"

     uploaded_file_location = @s.upload('./spec/uploader/test.png', "super/test/key/#{now}", 'uploader_field_name')
     
     expect(expected_file_location).to eq(uploaded_file_location)
 end
end
