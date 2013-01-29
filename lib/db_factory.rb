require "singleton"
require "find"

class DBFactory

  include Singleton

  def initialize
    @file_cache = {}
    path = (File.expand_path("..", __FILE__)).gsub("/lib", "") + "/config.yml"
    config_file = YAML::load(File.open(path))
    @db = DBI.connect("DBI:Mysql:%s:%s" % [config_file["mysql_db"],config_file["mysql_host"]], config_file["mysql_user"], config_file["mysql_password"])
  end

  @file_cache = {}

  def db
    @db
  end

  def sql_at(file_name)
    path = (File.expand_path("..", __FILE__)).gsub("/lib", "") + "/sql/"
    if @file_cache[file_name] == nil
      file = File.open(path + file_name, "rb")
      contents = file.read
      @file_cache[file_name] = contents
      file.close
    end
    @file_cache[file_name]
  end

end