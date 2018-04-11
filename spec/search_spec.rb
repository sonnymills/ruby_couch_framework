require 'spec_helper'
require 'test'
require 'search_base'
describe SearchBase do
  before :each do
    t = Test.new 
    t.create 
    t.first_name = "testie"
    t.last_name = "McTest" 
    @now = Time.now
    t.set_protected('trashpanda_id','12345')
    t.save
    @s = SearchBase.new('test')
  end
  after :each do 
    begin
      #File.unlink(File.join File.dirname(__FILE__), "./development/test_db.yml")
    rescue 
      puts "no DB file to delete... running with couch?"
    end  
  end
  it "can get all ids" do
    expect(@s.get_all_ids).to be_kind_of(Array)
  end
  it "can get only ids with specific attribute" do
     puts "inspecting s #{@s.inspect}"
     ids = @s.get_ids_with_details('first_name'=> 'testy')
     expect(ids.length).to eq(1)
  end
end
