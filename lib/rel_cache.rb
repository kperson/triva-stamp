require "dbi"
require_relative "db_factory"
require "singleton"

class RelCache

  include Singleton

  def initialize
    @file_cache = {}
    @clean_rate = 100
    @rand = Random.new(1234)
    @is_setup = false
  end

	def set(key, object, expiry = -1)
    expire_time = expiry >= 0 ? expiry : -1
    puts expire_time
    puts object
    puts key
    if expire_time == -1



      db_connection.do(DBFactory.instance.sql_at("cache/cache_set_forever.sql"), key, YAML::dump(object).to_s)
    else
      db_connection.do(DBFactory.instance.sql_at("cache/cache_set.sql"), key, YAML::dump(object).to_s, expire_time)
    end
  end

	def get(key)
    data = db_connection.select_one(DBFactory.instance.sql_at("cache/cache_get.sql"), key)
    data != nil ? YAML::load(data["yaml_value"]) : nil
	end
  
  def get_and_expire_in(key, expiry = -1)
    value = get(key)
    if value != nil
      expire_in(key, expiry)
    end
    value
  end
	
	def delete(key)
    expire_in(key, 0)
	end
	
	def flush
    db_connection.do(DBFactory.instance.sql_at("cache/cache_flush.sql"))
	end
	
	def expire_in(key, expiry = -1)
    expire_time = expiry >= 0 ? expiry : -1
    if expire_time == -1
      db_connection.do(DBFactory.instance.sql_at("cache/cache_extend_forever.sql"), key)
    else 
      db_connection.do(DBFactory.instance.sql_at("cache/cache_extend.sql"), expire_time, key)
    end
  end
  
  def clean(connection)
    connection.do(DBFactory.instance.sql_at("cache/cache_clean.sql"))
  end

  def setup(connection)
    if connection.select_one("SHOW TABLES LIKE 'sudo_cache'").nil?
      connection.do(DBFactory.instance.sql_at("cache/cache_create.sql"))
    end
  end

  def db_connection
    connection = DBFactory.instance.db
    if !@is_setup
      @is_setup = true
      setup(connection)
    end

    if @rand.rand(0..@clean_rate) == 0
        clean(connection)
     end
    connection
  end
end