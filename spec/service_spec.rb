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
  it "can set multiple fields config roots" do 
    @t.set_fields_config_root(['/parent','/parent/child1','/parent/child1/child2'])
    puts "this is fields #{@t.get_fields}"
    expect(@t.get_fields.has_key?('parent')).to be
    expect(@t.get_fields.has_key?('child_license')).to be
    expect(@t.get_fields.has_key?('child_2_license_something')).to be
  end 
   it "throws a descriptive error when no configs are loaded" do 
    expect{@t.set_fields_config_root(['/no_configs_here'])}.to raise_error(/no configs were loaded/) 
  end
  it "can set additional config and override" do 
    @t.add_fields_config('test_override.yml') 
    expect(@t.get_fields.has_key?('phone_number')).to be
    expect(@t.get_fields.has_key?('first_name')).to be
  end
  it "can handle configs in a dir tree" do 
    @t.add_fields_config('test_override.yml') 
    expect(@t.get_fields.has_key?('phone_number')).to be
    @t.add_fields_config('nested/test.yml') 
    expect(@t.get_fields.has_key?('nested_first_name')).to be
  end
  it "throws a descriptive error when a key is duplicated" do 
    expect{@t.add_fields_config('same_name.yml')}.to raise_error(/there are duplicate/) 
  end
  it "can handle configs with just a path" do 
    @t.add_fields_config('nested') 
    expect(@t.get_fields.has_key?('first_file')).to be
    expect(@t.get_fields.has_key?('second_file')).to be
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
  it "can get fields for step" do
    expect(@t.get_fields_by_step(2).length).to eq 3
  end
  it "can get a step for a field" do 
    expect(@t.get_step_for_field('step_2_name')).to eq 2 
  end
  it "can get the next step" do 
    @t.add_fields_config('nested') 
    expect(@t.get_next_step(1)).to eq 2
    expect(@t.get_next_step(2)).to eq 3
    expect(@t.get_next_step(3)).to eq 4
    expect(@t.get_next_step(4)).to eq 'final'
  end
  it "can return a summary of the entity" do 
      expect(@t.summary.keys).to contain_exactly('name','progress','next_step','step_description')
      expect(@t.summary['progress']). to be_kind_of(Float)
      expect(@t.summary['next_step']). to be_kind_of(String)
      
  end
end

