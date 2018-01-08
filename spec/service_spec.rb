require 'spec_helper'
require 'test'
describe Test do
  before :each do
    @t = Test.new
    @t.set_config_root(File.dirname(__FILE__))
  end
  after :all do 
    # think about deleting FS db   
  end
  it "can set a different root for configs" do
    t = Test.new
    t.set_config_root(File.dirname(__FILE__))
    expect(t.get_fields.kind_of?(Hash)).to be true 
  end 
  it "it has a default fields hash" do
    expect(@t.get_fields.kind_of?(Hash)).to be true 
  end
  it "can save a user" do 
     @t.create 
    expect(@t.save).to be 
  end
  it "has an id after load" do 
      @t.create 
      id = @t.id 
      t = Test.new
      t.load(id)
      expect(t.id).to eq(@t.id)

  end 
  it "can create a user and get an id" do
     @t.create 
     expect(@t.id.kind_of?(String)).to be true
  end
  it "has accessors after create" do 
     @t.create 
     expect(@t).to respond_to(:email)
  end
  it "retains values after set" do 
     @t.create
     email_addy = "mung@test.com" 
     @t.email = email_addy
     expect(@t.email).to eq(email_addy)
  end
  it "retains values after load" do 
     @t.create
     email_addy = "mung@test.com" 
     @t.email = email_addy
     expect(@t.email).to eq(email_addy)
      @t.save
     lt = Test.new
     lt.load(@t.id)
     expect(lt.email).to eq(email_addy)
  end
end

