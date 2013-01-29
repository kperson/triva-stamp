require_relative "../lib/cache_factory"
require_relative "../lib/db_factory"
require_relative "trivia"
require "singleton"
require_relative "base_dao"

class TriviaDAO < BaseDAO

  include Singleton

  def new_trivia(name)
    trivia = Trivia.new(SecureRandom.hex(30))
    trivia.name = name
  end

  def save(trivia, member_id)
    key_name = "trivia-" + trivia.trivia_id
    cache = CacheFactory.instance.cache
    cache.set(key_name, trivia)

    db = DBFactory.instance.db
    db.do(DBFactory.sql_at("trivia/trivia_save.sql"), trivia.trivia_id, member_id, key_name, trivia.name)
  end

  def delete(trivia_or_trivia_id)
    trivia_id = Trivia.resolve_id(trivia_or_trivia_id)
    cache = CacheFactory.instance.cache
    cache.delete "trivia-" + trivia_id

    db = DBFactory.instance.db
    db.do(DBFactory.sql_at("trivia/trivia_delete.sql"), trivia_id)
  end

  def get_by_id(trivia_id)
    cache = CacheFactory.instance.cache
    cache.get("trivia-" + trivia_id)
  end

  def get_by_id_member(trivia_id, member_id)
    db = DBFactory.instance.db
    data = db.select_one(DBFactory.sql_at("trivia/trivia_find_one_by_member.sql"), member_id, trivia_id)
    !data.nil? ? YAML::load(data["yaml_value"]) : nil
  end

  def get_by_member(member_id, skip = 0, limit = 10)
    list = []
    db = DBFactory.instance.db
    st = db.execute(DBFactory.sql_at("trivia/trivia_find_many_by_member.sql") % [skip, limit], member_id)
    st.fetch_hash do |row|
     list << YAML::load(row["yaml_value"])
    end
    list
  end

end