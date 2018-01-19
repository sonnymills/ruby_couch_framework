require 'spec_helper'
require 'service_base'
require 'search_base'
describe SearchBase do
  before :each do
    @e = ServiceBase.new('search')
    @now = Time.now
    hash = {'name' => @now, 'stuff' => 'maybe' }
    @e.seed_doc(hash)
    @e.merge_hash(hash)
    @e.save
    @s = SearchBase.new('search')
  end
  after :each do 
    #begin
    #  File.unlink(File.join File.dirname(__FILE__), "../development/search_db.yml")
    #rescue 
    #  puts "no DB file to delete... running with couch?"
    #end  
  end
  it "can get all ids" do
    expect(@s.get_all_ids).to be_kind_of(Array)
  end
  it "can get only ids with specific attribute" do
     puts "inspecting s #{@s.inspect}"
     ids = @s.get_ids_with_details('name'=> @now)
     expect(ids.length).to eq(1)
  end
end
