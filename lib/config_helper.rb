#config_helper.rb
require 'json/ext'
require 'yaml'
module ConfigLoader
  def load_config(file = 'config.yml') 
    raw_config = YAML.load_file(file)
    raise "unable to load config from #{file}" unless raw_config.kind_of?(Hash)
    env_var = ENV['RACK_ENV']
    env_var = ENV['ENVIRONMENT'] if ENV['ENVIRONMENT']
    env_var = env_var || 'development'
    return raw_config[env_var]
  end 
end

