require "securerandom"

class Trivia

  attr_accessor :name, :is_active
  attr_reader :questions
  attr_reader :trivia_id

  def initialize(trivia_id)
    @trivia_id = trivia_id
    @questions = []
  end

  def add_question(question, answers, multiple_choice = nil, image = nil)
    if !answers.is_a? Array
      answers = [answers]
    end

    question = {:question => question, :answers => answers, :multiple_choice => multiple_choice, :image => image, :question_id => SecureRandom.hex(30).to_s}
    @questions << question
    question
  end

  def remove_question(question_id_or_hash)
    if question_id_or_hash.is_a? Hash
      question_id_or_hash = hash[:question_id]
    end
    @questions = @questions.delete_if { |x| x[:question_id] == question_id_or_hash }
  end

  def change_question(question, answers, multiple_choice = nil, image = nil, question_id)
    if !answers.is_a?(Array)
      answers = [answers]
    end
    index = @questions.index{|x| x[:question_id] == question_id}
    if index != nil
      @questions[index][:question] = question
      @questions[index][:answers] = answers
      @questions[index][:image] = image
      @questions[index][:multiple_choice] = multiple_choice
      @questions[index][:image] = image
    end
  end

  def next_question(question_id)
    index = @questions.index{|x| x[:question_id] == question_id}
    if index != nil
      @questions[index + 1]
    else
      nil
    end

  end

  def prev_question(question_id)
    index = @questions.index{|x| x[:question_id] == question_id}
    if index != nil && index > 0
      @questions[index - 1]
    else
      nil
    end
  end
end