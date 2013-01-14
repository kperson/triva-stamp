require "template-inheritance"
require "sinatra/base"

TemplateInheritance::Template.paths << File.expand_path("..", __FILE__) + "/views"
set :public_folder, File.expand_path("..", __FILE__) + "/public"


helpers do
  def ihaml(template)

    template = TemplateInheritance::Template.new(template)
    hash = { }
    self.instance_variables.each { |var|
      hash[var.to_s[1..-1].to_sym] = instance_variable_get(var)
    }
    template.render(hash)
  end

  def content_box(&block)
    open :div, :class => "holder" do # haml helper
      open :div, :class => "top"
      open :div, :class => "content" do
        block.call
        open :div, :class => "bottom"
      end
    end
  end

  def cycle(even, odd)
    @_cycle ||= reset_cycle
    @_cycle == true ? even : odd
  end

  def reset_cycle
    @_cycle = true
  end
end