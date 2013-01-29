require "singleton"
require_relative "member"
require_relative "base_dao"

class MemberDAO < BaseDAO

  include Singleton

  def save(member)
    db = DBFactory.db
    db.do(DBFactory.sql_at("member/member_save.sql"), trivia_id)
  end

  def find_by_email_password(email, password)
    db = DBFactory.db
    row = db.select_one(DBFactory.sql_at("member/member_find_one_by_username_or_email.sql"), email, email)
    process_password_row(row, password)
  end

  def find_by_user_name_password(user_name, password)
    db = DBFactory.db
    row = db.select_one(DBFactory.sql_at("member/member_find_one_by_username_or_email.sql"), user_name, user_name)
    process_password_row(row, password)
  end

  def find_by_user_name(user_name)

  end

  def find_by_email(email)

  end

  def create_user(user_name, email, password)
    hashed_password = BCrypt::Password.create(password).to_s
    member_id = SecureRandom.hex(30).to_s
    db = DBFactory.db
    db['AutoCommit'] = false
    dbh.transaction do |dbh|
      dbh.do(DBFactory.sql_at("member/member_create.sql"), member_id, user_name)
      dbh.do(DBFactory.sql_at("member/member_create_password.sql"), member_id, hashed_password, email)
    end
    db['AutoCommit'] = true
  end

  def process_password_row(row, password)
    if password == BCrypt::Password.new(row["password"])
      member = Member.new(row["member_id"])
      member.user_name = row["user_name"]
    else
      nil
    end
  end



  private :process_password_row
end