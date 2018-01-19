#service_helper.rb
require 'json/ext'
require 'couchrest'
require 'dev_json_store'
require 'yaml'
require 'config_helper'

class ServiceBase
  include ConfigLoader
  attr_accessor :db, :doc, :config, :id, :db_name, :fields

  def initialize(db_name,config = nil)
    config_file =  config.nil? ? 'config.yml' : config
    @config_root = File.dirname(caller.first.split(':').first)
    config =  File.join @config_root, config_file
    @config = load_config(config) 
    @db_name = db_name
    raise "configuration not hash as expected got #{@config.class}" unless @config.kind_of?(Hash)
    @db = create_db_connection(@db_name,@config_root)
    @fields = Hash.new
    self.add_fields_config("#{db_name}.yml")
  end
  def set_config_root(full_path)
      @config_root = full_path 
  end 
  def get_fields(name = nil) 
      return @fields 
  end
  def add_fields_config(config)
        entity_config = File.join @config_root , config
      if File.file?(entity_config)
        fields = YAML.load_file(entity_config)
        @fields.merge!(fields) 
      elsif File.directory?(entity_config)  
        dir_files = Dir["#{entity_config}/*yml"]
        dir_files.each do |f|
          fields = YAML.load_file(f)
          @fields.merge!(fields) 
        end
      else
        raise Error, "unable to match #{entity_config} with file or directory" 
      end
  end 
  def create
      @created = true 
      @id = seed_doc(get_fields) 
      load(@id)
  end
  def seed_doc(default_fields)
    response =@db.save_doc('fields' => default_fields.keys,'protected'=>{})
    response['id']
  end 
  def temp
      default_fields = get_fields
      @doc = {'fields' => default_fields.keys }
      generate_accessors
  end
  def save 
    data = Hash.new
    get_fields.keys.each do |attr|
        data[attr] = instance_variable_get("@#{attr}")
    end
    @doc.merge!({'fields' => data}) unless @doc.nil?
    @doc = data if @doc.nil?
    response =@db.save_doc(@doc)
    response['id']
  end

  def load(id)
    raise "ID needed to load" unless id
    begin
      @doc = @db.get(id)
    rescue Exception => e
      @doc = Hash.new 
    end
    begin
      generate_accessors 
      self.id = id 
    rescue Exception => e
      raise "failed to generate accessors because #{e.message}"  
    end
  end
  def delete(doc)
    begin
      @doc = @db.delete_doc(doc)
    rescue Exception => e 
      raise "failed to delete doc: #{e}"
    end
  end
  def find(view,query)
    resp = @db.view(view,query)
    resp
  end
  def create_db_connection(db_name, config_root)
      if  ENV['MODEL_ENV'] && !ENV['MODEL_ENV'].eql?('local') 
        server = CouchRest.new
        db = CouchRest.database!("http://#{config['couch_box']}:#{config['port']}/#{db_name}")
      else
        db = DevJsonStore.new(db_name,config_root)
      end
      return db 
  end
  def generate_accessors
      raise "@doc not defined" unless @doc
      data = @doc.to_hash
      if data.kind_of?(Hash) and data.has_key?('fields')
        data['fields'].each do |a,v| 
          self.class.send(:attr_accessor,a) 
          instance_variable_set("@#{a}",v)
        end
      end
  end
  def set_protected(key,value)
     @doc['protected'][key] = value 
  end
  def get_protected(key)
     return @doc['protected'][key] || false
  end
  def merge_hash(data)
        data.each do |a,v| 
          instance_variable_set("@#{a}",v)
          i_v = instance_variable_get("@#{a}")
          #puts "value is now set to #{i_v}"
        end
  end
  def get_all_ids(params = nil)
        @db.all_doc_ids
  end
  def upload_attachment(attachment_path,filename,field)
      s = S3Uploader.new
      key = [self.class.name.downcase,@id,field].join('/')
      raise "missing required parameter" unless attachment_path && key
      
      path = s.upload(attachment_path,key,filename) 
      return path 
  end
  def create_and_populate(data)
      self.create
      self.merge_hash(data)
      self.save
  end
  def finalize
      set_protected('finalized', true)
  end
  def is_finalized?
      get_protected('finalized')
  end
  def get_form_fields_by_step(step)
      return self.get_form_fields.select{|k,v| v['step'].to_s == step.to_s}
  end
  def get_fields_by_step(step)
      return self.get_fields.select{|k,v| v['step'].to_s == step.to_s}
  end
  def get_next_step(current_step) 
        
        steps = get_fields.each_value.map{|v| v['step']}.uniq
       # i = steps.index(current_step ? current_step : 1 ).to_i
       # puts "this is the current step @#{current_step}@"
        ns = 0
        
        #puts "this is the current step @#{current_step}@"
        #puts "these are available steps @#{steps}@"
        #puts "#{steps.index(current_step)} < #{steps.index(steps.last)}"
        if steps.index(current_step.to_i) < steps.index(steps.last)
            return current_step.to_i + 1 
        else 
           return 'final'
        end
  end 
  def is_compound?(field)
    return get_fields[field] && get_fields[field]['compound'] ? true : false
  end
  def reload 
    @db = create_db_connection(@db_name,@config)
  end
end
