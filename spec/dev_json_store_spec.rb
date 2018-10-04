require 'service_base'
require 'spec_helper'
require 'dev_json_store'

describe 'DevJsonStore' do

  it 'can get a yml db file path that makes sense' do
    db_name="./override_dev_root"
    DevJsonStore.get_db_file(db_name)

    true.should == false
  end
  it 'can load a yml db' do
    db_name="./override_dev_root"
    DevJsonStore.load_file_db(db_name)

    true.should == false
  end
end