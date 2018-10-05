require 'service_base'
require 'spec_helper'
require 'dev_json_store'

describe 'DevJsonStore' do

  it 'can load a yml db' do
    db_name = "./override_dev_root"
    dev_store = DevJsonStore.new('test', db_name)

    expect(dev_store).to be
  end

  it 'can get a yml db file path that makes sense' do
    db_name = "./override_dev_root"
    dev_store = DevJsonStore.new('test', db_name)

    db_file = dev_store.get_db_file("poop_on_a_stick")

    expect(db_file).to eq("./override_dev_root/development/poop_on_a_stick_db.yml")
  end
end