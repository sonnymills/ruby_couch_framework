require 'spec_helper'
require 'user'
describe User do
  before :each do
    @u = User.new
  end
  after :all do 
    # think about deleting FS db   
  end
  it "it has a default fields hash" do
    expect(@u.get_fields.kind_of?(Hash)).to be true 
  end
  it "can save a user" do 
     @u.create 
    expect(@u.save).to be 
  end
  it "has an id after load" do 
      @u.create 
      id = @u.id 
      u = User.new
      u.load(id)
      expect(u.id).to eq(@u.id)

  end 
  it "can create a user and get an id" do
     @u.create 
     puts @u.id 
     expect(@u.id.kind_of?(String)).to be true
  end
  it "has accessors after create" do 
     @u.create 
     expect(@u).to respond_to(:email)
  end
  it "retains values after set" do 
     @u.create
     email_addy = "mung@test.com" 
     @u.email = email_addy
     expect(@u.email).to eq(email_addy)
  end
  it "retains values after load" do 
     @u.create
     email_addy = "mung@test.com" 
     @u.email = email_addy
     expect(@u.email).to eq(email_addy)
      @u.save
     lu = User.new
     lu.load(@u.id)
     puts "attributes are #{lu.instance_variables}"
     expect(lu.email).to eq(email_addy)
  end
end

