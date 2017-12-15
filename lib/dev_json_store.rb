class DevJsonStore
  require 'securerandom'
  def initialize(db_name,config)
      @loaded_id = nil 
      @db_name = db_name 
      @db_hash = load_file_db(@db_name)
      @db_hash = Hash.new unless @db_hash.kind_of?(Hash)
      
  end
  def get_db_file(db_name)
    return File.join(File.dirname(__FILE__), "development/#{db_name}_db.yml")
  end
  def load_file_db(db_name)
      db_file = get_db_file(db_name)
      @db_hash = Hash.new
      if File.file?(db_file) 
        @db_hash = YAML.load_file(db_file)
      else 
      end
      return @db_hash
  end
  def get_keys
  end
  def all_doc_ids
      return @db_hash.keys
  end
  def save_doc(data)
      doc_id = @loaded_id || SecureRandom.uuid 
      @db_hash = load_file_db(@db_name)
      @db_hash[doc_id] = data 
      write_to_file(@db_name)
      return {'id' => doc_id}

  end
  def write_to_file(db_name)
      db_file = get_db_file(db_name)
      File.open(db_file,'w') do |f|
        f.write @db_hash.to_yaml
      end
  end

  def get(id)
      @loaded_id = id
      db_hash = load_file_db(@db_name)
      return db_hash[id]
  end

  def delete_doc(id)
      write_to_file
  end

  def view(view,query)
      query[:q] = query[:key]
      self.view_search(view,query)
  end
  def search(params ={})
      return @db_hash.keys  
  end
	def view_search(view,params={}) 
      block = params[:block] || 'fields'
      ( stub, complex_key) = view.split('/')
      key = complex_key.split('-').shift  
      #puts "this is my block #{block} this is my key #{key} and params #{params}"
      hits =  Hash.new
      @db_hash.each do |k,v| 
        #puts "I have a V #{v}"
        #puts "I have a VB #{v[block]}"
        begin 
          hits[k] = v if v[block][key] == params[:q]
        rescue Exception => e
          #puts "unhandled data for #{e.message}"
        end
      end

      result = {'rows'=>[]} 
      hits.each do |k,v|
        result['rows'].push({'id' => k, 'value' => v})
      end 
      return result
  end
end

