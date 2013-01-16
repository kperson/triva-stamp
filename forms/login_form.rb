require "sinatra/activerecord"

class LoginForm

  include ActiveModel::Validations

  attr_accessor :username, :password

  validates_presence_of :username, :message => "Please enter an username"
  validates_presence_of :password, :message => "Please enter a password"

  def initialize(hash = {})

    hash.each do |k,v|
      if k != "_csrf"
        send("#{k}=",v)
      end
    end
  end


end