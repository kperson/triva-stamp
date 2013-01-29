require "sinatra"
require "sinatra/reloader"
require_relative "helpers"
require "haml"
require "yaml"
require "template-inheritance"
# require "mysql"
require "find"
require_relative "lib/cdn_upload"
require "sinatra/config_file"
require_relative "lib/resolve"
require "rack/csrf"
require_relative "forms/login_form"
require_relative "lib/user"

config_file "config.yml"

use Rack::Csrf, :raise => true
set :session_secret, "76d82a386c8482f283291ba52dc13719"
set :sessions => true

get "/" do
  #a = session
  # serialized_object = YAML::dump(a)
  #puts YAML::load(serialized_object)
  #=end

   redirect "/login/"
  #@fonts = ["arial","helvetica","tahoma","GOthAm"];
  #ihaml "kelton.html"
end


get "/hello" do
  puts @user_session
  @user_session.add_role(:contributor)
  @user_session.save
end


get "/testme" do
  puts @user_session.roles

end


get "/login/?" do
	@form = session[:login_form].nil? ? LoginForm.new : session[:login_form]  
	session.delete(:login_form)
  ihaml "login.html"
end

post "/login/" do
  @form = LoginForm.new(params)
  @form.errors
  ihaml "login.html"
end

get "/test" do
  cdn = CDNUpload.new
  cdn.post_to_cdn
  cdn.delete_old_from_cdn
  cdn.write_config

  "Hello World!"
end

before do
  @config = settings
  session[:id] ||= SecureRandom.uuid
  @user_session = User.get_user_by_session_id(session[:id])

end

