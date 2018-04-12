#search_helper.rb
require 'json/ext'
require 'couchrest'
require 'service_base'

class SearchBase < ServiceBase
	attr_accessor :db, :doc

	def find(view,query)
		resp = @db.view(view,query)
		resp
	end
	def all_doc_ids(params = nil)
      @db.all_doc_ids
	end
  def doc_exists?(id)
      return self.all_doc_ids.include?(id)
  end
  def get_ids_with_details(search_hash, params = {})
      results = Array.new
      params[:block] = params[:block] || 'fields'
      puts "set block to #{params[:block]}"
      
      search_hash.each do |k,v| 
					params[:key] = v
          view = "accessor/#{[k,params[:block]].join('-')}"
        begin
          r = self.find(view,params)   
          results.push(r['rows'].map{|r| r['id']})
        rescue Exception => e
          #puts "this is the exception cause #{e.message}"
          generate_view(k,params[:block]) if e.message =~ /^404/
          r = self.find(view,params)   
          results.push(r['rows'].map{|r| r['id']})
        end
      end
      return results.flatten
  end
  def get_attribute_for_ids(attr, ids)
      results = Array.new
      #puts "set block to #{params[:block]}"
      
      view = "accessor/#{attr}-fields"
      begin
        r = self.find(view,{:keys => ids})   
        results.push(r['rows'].map{|r| r['id']})
      rescue Exception => e
        puts "this is the exception cause |#{e.message}"
        if e.message =~ /^404/
          puts 'matched error and trying to generate' 
          generate_view(attr,'fields') 
        else
          puts 'did not catch 404'
        end
        r = self.find(view,{:keys => ids})   
        results.push(r['rows'].map{|r| r['id']})
      end
      return results.flatten
  end
	def load_docs(ids) 
		begin
			resp = @db.get_bulk(ids)
			resp
		rescue Exception => e 
			#puts "failed with #{e.message}"
		end 
	end
	def search(name,query) 
		#puts "trying to render view #{view}"
		puts "sending query #{query} #{name}"
    if query['q'] and query['q'].length > 0
      #need some custom args here?
    else
      query['q'] = '*' 
      query['sort'] = '\created_date'
    end
    if query.has_key?('cat') 
      query['q'] += " AND type:#{query['cat']}"
    
    end 
    if query.has_key?('cause') and query['cause'].length > 1 
      query['q'] += " AND cause:#{query['cause']}"
    end 
    
    if query.has_key?('min') ||  query.has_key?('max') 
      min = 0 
      max = 10000000000
      min = query['min'] if query['min'] 
      max = query['max'] if query['max']
      query['q'] += " AND total_value<double>:[ #{min} TO #{max}]" 
    end
    
    page = query['p'].to_i 
    query.delete('p')
    page_size = query['s'].to_i
    query.delete('s')
    pagination = {'limit' => page_size, 'skip' => (page > 0 ?  page - 1 : 0 )*page_size }
    query.merge!(pagination)
    
		index = query["index"] || "package_and_items"
   puts "query is #{query}" 
		result =  @db.fti(name,index,query)
		ids =  result['rows'].map{|r| r['id']}
    return { "total" => result['total_rows'], "ids" => ids, "rows" => result["rows"] }
		
	end
  def generate_id_query(ids)
      return ids.map{|i| {"_id" => {'$eq' => i}} }.to_json
      
  end
  def generate_view(key,block = 'fields')
      @ac_doc = nil
      
      begin
        puts "trying to load view"
        @ac_doc = @db.get('_design/accessor')
        raise "fail" unless @ac_doc
      rescue 
        puts "failed to load view"
        @db.save_doc({ "_id" => "_design/accessor", 'views' => {}})
        puts "saved view"
        @ac_doc = @db.get('_design/accessor')
        puts "loaded db obj"
      end
      puts "this is the @ac_doc #{@ac_doc['views']}"
      @ac_doc['views'][ [key,block].join('-') ] = { 'map' => "function(doc) {\n  emit(doc['#{block}']['#{key}'], doc.id);\n}" }
      @db.save_doc(@ac_doc) 
      self.reload
  end
end

