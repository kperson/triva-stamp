require_relative "rel_cache"
require "singleton"

class CacheFactory

  include Singleton

  def cache
    RelCache.instance
  end

end