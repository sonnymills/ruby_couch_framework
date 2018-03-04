require 'service_base' 
class Landuse < ServiceBase 
  attr_accessor :id, :created
  def initialize(config_roots)
    super('landuse')  
    self.set_fields_config_root(config_roots)
  end
  def get_form_fields 
    super('landuse') 
  end 
end

