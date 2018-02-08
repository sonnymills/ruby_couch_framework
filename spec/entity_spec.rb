require 'spec_helper'
require 'test'
describe Test do
  before :each do
    @t = Test.new
  end
  after :all do 
    # think about deleting FS db   
  end
  it "can set a different root for configs" do
    #t = Test.new
    @t.set_config_root(File.dirname(__FILE__))
    expect(@t.get_fields.kind_of?(Hash)).to be true 
  end  
  it "can set additional config and override" do 
    @t.add_fields_config('test_override.yml') 
    expect(@t.get_fields.has_key?('phone_number')).to be
    expect(@t.get_fields.has_key?('first_name')).to be
  end
  it "can pass in an array of paths to use as config roots" do
      t = Test.new(['/parent','/parent/child1','/parent/child1/child2'])
      
  end
  it "can handle configs in a dir tree" do 
    @t.add_fields_config('test_override.yml') 
    expect(@t.get_fields.has_key?('phone_number')).to be
    @t.add_fields_config('nested/test.yml') 
    expect(@t.get_fields.has_key?('nested_first_name')).to be
  end
end

