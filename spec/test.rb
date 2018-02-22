require 'service_base' 
class Test < ServiceBase 
  attr_accessor :id, :created
  def initialize
    self.set_config_root(File.dirname(__FILE__))
    super('test')  
    self.set_fields_config_root([File.dirname(__FILE__)])
  end
  def get_form_fields 
    super('test') 
  end 
end

