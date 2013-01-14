require "sinatra/config_file"

config_file "../cdn.yml"

module Trivia

  class Resolve

    def self.path(name)
      settings.cdn ? settings.cdn_dir + name : name
    end
  end

end