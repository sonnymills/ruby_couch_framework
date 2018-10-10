#devservice_base.rb
require 'json/ext'
require 'couchrest'
require 'dev_json_store'
require 'yaml'
require 'config_helper'
require 's3_uploader'

class ServiceBase
  include ConfigLoader
  attr_accessor :db, :doc, :config, :id, :db_name, :fields, :data_store_root, :config_root

  def initialize(db_name, options_hash = nil)
    @config_root = File.dirname(caller.first.split(':').first)
    begin
      config_file = options_hash["config_file"] || 'config.yml'
    rescue
      config_file =  'config.yml'
    end
    config = File.join @config_root, config_file
    @config = load_config(config)
    @db_name = db_name
    raise "configuration not hash as expected got #{@config.class}" unless @config.kind_of?(Hash)
    begin
      @data_store_root = options_hash[:data_store_root]
    rescue Exception => e
      @data_store_root = @config_root
    end
    @db = create_db_connection(@db_name, @data_store_root)
    @doc = Hash.new
    @fields = Hash.new
    @doc['protected'] = Hash.new
    self.add_fields_config("#{db_name}.yml")
  end

  #def set_config_root(full_path)
  #    @config_root = full_path
  #end
  def get_fields(name = nil)
    return @fields
  end

  def set_fields_config_root(config_roots)
    fields_config_root = config_roots || @config_root
    fields_config_root.each do |fcr|
      full_root = File.join fcr, @db_name
      named_file = File.join fcr, @db_name + ".yml"
      self.add_fields_config(full_root)
      self.add_fields_config(named_file)
    end
    raise "no configs were loaded" unless @fields.keys.length > 0
  end

  def add_fields_config(config)
    #entity_config = File.join @config_root , config
    entity_config = config
    if File.file?(entity_config)
      fields = YAML.load_file(entity_config)
      merge_fields(fields)
    elsif File.directory?(entity_config)
      dir_files = Dir["#{entity_config}/*yml"]
      dir_files.each do |f|
        fields = YAML.load_file(f)
        merge_fields(fields)
      end
    else
      #puts "unable to match #{entity_config} with file or directory moving on"
    end
  end

  def merge_fields(fields)
    if (fields.keys & @fields.keys).length > 0 #check for hash key intersection
      raise "there are duplicate fields #{fields.keys & @fields.keys}"
    end
    @fields.merge!(fields)
  end

  def create
    @created = true
    @id = seed_doc(get_fields)
    load(@id)
  end

  def seed_doc(default_fields)
    response = @db.save_doc('fields' => default_fields.keys, 'protected' => @doc['protected'])
    response['id']
  end

  def temp
    default_fields = get_fields
    generate_accessors({'fields' => default_fields.keys})
  end

  def save
    data = Hash.new
    get_fields.keys.each do |attr|
      data[attr] = instance_variable_get("@#{attr}")
    end
    @doc.merge!({'fields' => data}) unless @doc.nil?
    @doc = data if @doc.nil?
    response = @db.save_doc(@doc)
    response['id']
  end

  def load(id)
    raise "ID needed to load" unless id
    begin
      @doc = @db.get(id)
    rescue Exception => e
      #puts "Failed to get the doc because #{e.message}"
      @doc = Hash.new
    end
    begin
      generate_accessors(@doc)
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

  def find(view, query)
    resp = @db.view(view, query)
    resp
  end

  def create_db_connection(db_name, config_root)
    if ENV['MODEL_ENV'] && !ENV['MODEL_ENV'].eql?('local')
      server = CouchRest.new
      db = CouchRest.database!("http://#{config['couch_box']}:#{config['port']}/#{db_name}")
    else
      db = DevJsonStore.new(db_name, config_root)
    end
    return db
  end

  def generate_accessors(doc)
    raise "doc not defined" unless doc
    data = doc.to_hash
    if data.kind_of?(Hash) and data.has_key?('fields')
      data['fields'].each do |a, v|
        self.class.send(:attr_accessor, a)
        instance_variable_set("@#{a}", v)
      end
    end
  end

  def set_protected(key, value)
    @doc['protected'][key] = value
  end

  def get_protected(key)
    return @doc['protected'][key] || false
  end

  def merge_hash(data)
    data.each do |a, v|
      instance_variable_set("@#{a}", v)
      i_v = instance_variable_get("@#{a}")
      #puts "value is now set to #{i_v}"
    end
  end

  def upload_attachment(attachment_path, filename, field)
    s = S3Uploader.new('everything', 'private')
    key = [self.class.name.downcase, @id, field].join('/')
    raise "missing required parameter" unless attachment_path && key

    path = s.upload(attachment_path, key, filename, 'private')
    return path
  end

  def upload_image(attachment_path, filename, field)
    s = S3Uploader.new('profile_images', 'public-read')
    key = [self.class.name.downcase, @id, field].join('/')
    raise "missing required parameter" unless attachment_path && key

    path = s.upload(attachment_path, key, filename, 'public-read')
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

  def get_fields_by_step(step)
    return self.get_fields.select {|k, v| v['step'].to_s == step.to_s}
  end

  def get_step_for_field(field)
    return self.get_fields[field]['step']
  end

  def get_next_step(current_step)

    #steps = get_fields.each_value.map{|v| v['step']}.uniq
    steps = self.get_fields.map {|k, v| v['step']}
    steps.uniq!
    steps.sort!
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
    @db = create_db_connection(@db_name, @config)
  end

  def summary
    ns = ["next you'll need to brush your teeth", "now it's time for flossing", "next up, mouthwash"]
    s_desc = [
        "flossing is key for proper oral hygene, we'll help you with technique and timing",
        "brushing your teeth is an important part of total body health. Plus, if you don't brush you'll never get a date",
        "Mouthwash feels like the enemy but it's really your friend. That burning sensation is just it saying HELLO!"
    ]
    return {'name' => self.class, 'progress' => rand(), 'next_step' => ns.sample(1).first, 'step_description' => s_desc.sample(1).first}
  end
end
