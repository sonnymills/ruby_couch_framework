require 'service_base'
require 'spec_helper'

describe 'ServiceBase' do

  it "can instantiate service base with options_hash" do
    sb = ServiceBase.new('test', {data_store_root: './override_dev_root' })
    #sb = ServiceBase.new('test', {data_store_root: './override_dev_root', config_file: nil})
    sb.create
    sb.save
    expect(sb.id).to be

  end
  it "can set an alternative config root and preserve config root" do
    sb = ServiceBase.new('test', {data_store_root: './override_dev_root' })
    expect(sb.data_store_root).to eq './override_dev_root'
    expect(sb.config_root).to eq File.expand_path('./spec')
  end

  it "can instantiate flatfile data store in specified root" do
    sb = ServiceBase.new('test', {data_store_root: '/override_dev_root' })
    sb.create
    sb.save
    expect('./override_dev_root/test_db.yml').to be_an_existing_file

  end
end