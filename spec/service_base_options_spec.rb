require 'service_base'
require 'spec_helper'

describe 'ServiceBase' do
  before :each do
    @sb = ServiceBase.new('test', {data_store_root: './override_dev_root'})
  end
  after :each do
    begin
      File.delete File.expand_path('./override_dev_root/development/test_db.yml')
    rescue
      puts "no db file to delete"
    end
  end

  it "can instantiate service base with options_hash" do
    @sb.create
    @sb.save

    expect(@sb.id).to be
  end
  it "can set an alternative config root and preserve config root" do
    expect(@sb.data_store_root).to eq './override_dev_root'
    expect(@sb.config_root).to eq File.expand_path('./spec')
  end

  it "can instantiate flatfile data store in specified root" do
    @sb.create
    @sb.save
    dev_db = File.expand_path('./override_dev_root/development/test_db.yml')

    expect(File.exist?(dev_db)).to be_truthy
  end
end