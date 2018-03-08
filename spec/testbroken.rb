require 'service_base' 
class TestBroken < ServiceBase 
  attr_accessor :id, :created
  def initialize
    super('test_broken')  
    self.set_fields_config_root([File.dirname(__FILE__)])
  end
  def get_form_fields 
    super('test_broken') 
  end 
end

