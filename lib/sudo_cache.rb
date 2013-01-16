require "dbi"

class RelCache
    
  @@file_cache = {}
  @@clean_rate = 10
  @@prng = Random.new(1234)
  @@db_settings
  
	def set(key, object, expiry = -1)
    expire_time = expiry >= 0 ? expiry : -1
    if expire_time == -1
      RelCache.db_connection.execute(read_sql("cache_set_forever.sql"), key, YAML::dump(object).to_s)
    else
      RelCache.db_connection.execute(read_sql("cache_set.sql"), key, YAML::dump(object).to_s, expire_time)
    end
	end
	
	def get(key) 
    data = RelCache.db_connection.select_one(read_sql["cache_get.sql"], key)
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
    RelCache.db_connection.execute(read_sql("cache_flush.sql"))
	end
	
	def expire_in(key, expiry = -1)
    expire_time = expiry >= 0 ? expiry : -1
    if expire_time == -1
      RelCache.db_connection.execute(read_sql("cache_extend_forever.sql"), key)
    else 
      RelCache.db_connection.execute(read_sql("cache_extend.sql"), expire_time, key)
    end
  end
  
  def self.clean(connection)
    connection.execute(read_sql("cache_clean.sql"))
  end

  def self.read_sql(file_name)
    if @@file_cache[file_name] == nil
      file = File.open("../sql/" + file_name, "rb")
      contents = file.read
      @@file_cache[file_name] = contents
      file.close
    end
    @@file_cache[file_name]
  end

  def self.configure(db_settings)
    @@db_settings = db_settings
  end
  
  def self.db_connection
    connection = DBI.connect("DBI:Mysql:test:localhost", "root", "kelton")
    if @@prng.rand(0..@@clean_rate) == 0
        RelCache.clean(connection)
     end
    connection
  end
end