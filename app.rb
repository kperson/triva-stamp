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
  @js = ["hello.js"]
  @fonts = ["arial","helvetica","tahoma","GOthAm",'jim'];
  haml :test
end



before do
end

helpers do
  def load_js(js_files)
    my_js = ""
    js_files.each do |file|
      my_js.concat("<script type='text/javascript' src='#{file}'></script>\n")
    end
    my_js

  end
end

before do
  session[:id] ||= SecureRandom.uuid
end
