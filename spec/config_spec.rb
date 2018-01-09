require 'spec_helper'
require 'test'
let(:config_test) {Class.new {include ConfigLoader}}
describe Test do
  before :each do
      
  end
  after :all do 
    # think about deleting FS db   
  end
  it "can load a single config" do 
      config = @config_test.load_config('test.yml')
      
    
  end 
  it "can load an array of configs" do 
  end
end

