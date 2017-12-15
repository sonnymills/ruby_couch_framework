#user.rb
require 'service_helper'
require 'bcrypt'

class User < ServiceBase 
  attr_accessor :id, :created
  def initialize
    super('user')  
  end
  def get_fields 
    super('user') 
  end 
  def get_form_fields 
    super('user') 
  end 
  def set_password(password)
      hashed_p = BCrypt::Password.create(password).to_s 
      self.set_protected('password',hashed_p)
  end
  def check_password(password)
      hash = self.get_protected('password')
      return BCrypt::Password.new(hash) == password
  end
end
