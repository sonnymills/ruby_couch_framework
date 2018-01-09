require 'service_base' 
class Test < ServiceBase 
  attr_accessor :id, :created
  def initialize
    self.set_config_root(File.dirname(__FILE__))
    super('test')  
  end
  def get_fields 
    super('test') 
  end 
  def get_form_fields 
    super('test') 
  end 
end

