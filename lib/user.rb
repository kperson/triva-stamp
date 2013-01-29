require_relative "../lib/cache_factory"


class User

  attr_accessor :roles, :session_id

  def initialize

  end

  def self.fake_user(session_id)
    user = User.new
    user.session_id = session_id
    user.roles = [:admin, :basic]
    user
  end

  def in_role?(role_name)
    roles.include?(role_name)
  end

  def add_role(role_name)
    if !in_role?(role_name)
      roles << role_name
    end
  end

  def self.get_user_by_session_id(session_id)
    key_name = "user_session_" + session_id
    cache = CacheFactory.instance.cache
    user = cache.get(key_name)
    if user.nil?
      user = User.fake_user(session_id)
      cache.set(key_name, user, 3600)
    else
      cache.expire_in(key_name, 3600)
    end
    user
  end


  def save
    key_name = "user_session_" + session_id
    cache = CacheFactory.instance.cache
    cache.set(key_name, self, 3600)
  end

end