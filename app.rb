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


config_file "config.yml"

use Rack::Csrf, :raise => true
set :session_secret, "76d82a386c8482f283291ba52dc13719"
set :sessions => true

get "/" do
  #a = session
  # serialized_object = YAML::dump(a)
  #puts YAML::load(serialized_object)
  #=end


  @fonts = ["arial","helvetica","tahoma","GOthAm"];
  ihaml "kelton.html"
end

get "/test" do
  cdn = CDNUpload.new()
  cdn.post_to_cdn
  cdn.delete_old_from_cdn
  cdn.write_config

  "Hello World!"
end

before do
  @config = settings
  session[:id] ||= SecureRandom.uuid
end
