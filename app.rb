require "sinatra"
require "sinatra/reloader"
require_relative "helpers"
require "haml"
require "yaml"
# require "mysql"

get "/" do
  # con = Mysql.new('localhost', 'root', 'kelton', 'triva')
  # con.prepare("SELECT * FROM ")

  #a = session
  # serialized_object = YAML::dump(a)
  #puts YAML::load(serialized_object)
  #=end
  @fonts = ["arial","helvetica","tahoma","GOthAm",'jim'];
  haml :test
end

before do
  session[:id] ||= SecureRandom.uuid
end
