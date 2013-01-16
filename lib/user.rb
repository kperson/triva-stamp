class User

  attr_accessor :roles

  def initialize

  end

  def self.fake_user(session_id)
    user = User.new
    user.roles = ["admin".to_sym, "basic".to_sym]
    user
  end

  def in_role?(role_name)
    @roles.include?(role_name)
  end

end