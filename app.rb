require "sinatra"
require "sinatra/reloader"
require_relative "helpers"
require "haml"
require "yaml"
require "template-inheritance"
# require "mysql"
require "find"



get "/" do
  # con = Mysql.new('localhost', 'root', 'kelton', 'triva')
  # con.prepare("SELECT * FROM ")
  path = File.expand_path("..", __FILE__) + "/public/"
  Find.find(path) do |item|
    if !File.directory?(item)
      puts item.gsub(path, "")
    end
  end
  #a = session
  # serialized_object = YAML::dump(a)
  #puts YAML::load(serialized_object)
  #=end
  @fonts = ["arial","helvetica","tahoma","GOthAm"];
  ihaml "kelton.html"
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
