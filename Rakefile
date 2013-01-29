require_relative "lib/user"
require_relative "model/trivia"
require_relative "model/trivia_session"
require_relative "model/trivia_dao"
require_relative "lib/cdn_upload"
require "yaml"
require_relative "lib/rel_cache"
require_relative "lib/db_factory"

require "bcrypt"


namespace :sample do

  desc "Say Hi"
  task :hi do
    trivia = Trivia.new("Hello World")
    trivia.add_question("Do you like bagels?", ["sometimes", "never"])
    trivia.add_question("Do you like panera?", "sometimes")
    trivia_serial =  YAML::dump(trivia)
    puts trivia_serial
    trivia_load =  YAML::load(trivia_serial)
    puts trivia_load.questions[1]
  end

	desc "Push to CDN"
	task :push_cdn do
		cdn = CDNUpload.new
		cdn.post_to_cdn
    cdn.write_config
    cdn.delete_old_from_cdn

	end

  desc "Say Kelton"
  task :kelton do
    puts "Kelton"
  end

  desc "Say Hi To Kelton"
  task :talk => [:hi, :kelton] do
  end

  desc "List Fake user permissions"
  task :perm do
    user = User.fake_user("1234")
    puts user.roles
  end

   desc "Save Trivia"
  task :save_trivia do
    cache = CacheFactory.instance.cache
    trivia = Trivia.new(SecureRandom.hex(30))
    trivia.name = "My First Trivia"

    trivia.add_question("Do you like bagels?", ["sometimes", "never"])
    trivia.add_question("Do you like panera?", "sometimes")

    #cache.set("trivia", trivia, 60)

    TriviaDAO.instance

    #puts DBFactory.instance.sql_at("trivia/trivia_delete.sql")

    trivia2 = Trivia.new(SecureRandom.hex(30))
    trivia2.name = "My Second Trivia"
    trivia2.add_question("Do you like bagels?", ["sometimes", "never"])
    trivia2.add_question("Do you like panera?", "sometimes")

    #TriviaDAO.save(trivia, "kelton")
    #TriviaDAO.save(trivia2, "kelton")

    #puts TriviaDAO.get_by_member("kelton", 0, 2)[1].name


  end


  desc "Get Trivia"
  task :get_trivia do
    trivia = TriviaDAO.get_by_id_member("a5b318f564694cd6ef2057b0bfb370bfe82def6fdc57fb351ba3cd4b2ca3", "kelton")
    TriviaDAO.delete(trivia)
  end



  desc "Cache Sample"
  task :cache_read do
    TriviaDAO.get_by_member("kelton", skip = 3, limit = 3)
    #cache = RelCache.new
    #trivia_session = cache.get("trivia_session_d1acdcf348c8158f4d9e5f39dbfd74e2c5bdbe9a6f5e8ad8edce48ad0ea7")
    #puts trivia_session.curr_question
  end

end

desc "Default Task (talk)"
task :default => "sample:talk"

desc "Speak"
task :speak do
  puts "Speak"
end
