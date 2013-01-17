require_relative "lib/user"
require_relative "lib/trivia"
require "yaml"


namespace :sample do

  desc "Say Hi"
  task :hi do
    trivia = Trivia.new("Hello World")
    trivia.add_question("Do you like bagels?", ["sometimes", "never"])
    trivia.add_question("Do you like panera?", "sometimes")
    trivia_serial =  YAML::dump(trivia)
    puts trivia_serial
    trivia_load =  (Trivia)YAML::load(trivia_serial)
    puts trivia_load.questions[1]
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



end

desc "Default Task (talk)"
task :default => "sample:talk"

desc "Speak"
task :speak do
  puts "Speak"
end
