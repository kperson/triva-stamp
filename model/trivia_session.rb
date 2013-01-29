class TriviaSession
  
  attr_reader :session_id, :trivia, :curr_question_index
  
  def initialize(session_id, trivia)
    @session_id = session_id
    @trivia = trivia
    @status = []
    @trivia.questions.length.times do |x|
      @status << {:completion => "incomplete"}
    end
    @curr_question_index = 0
  end
  
  def is_correct?(question_or_question_id, answer)
    index = @trivia.index_of_question_or_question_id(question_or_question_id)
    !@trivia.questions[index][:answers].select{|x| x.downcase == answer.downcase}.empty?
  end
  
  def check_mark_increment(answer)
    correct = is_correct?(curr_question, answer)
    correct_status = correct ? "correct" : "incorrect"
    @status[@curr_question_index][:answer_status] = correct_status
    @status[@curr_question_index][:answer] = answer
    increment_question
    correct
  end

  def mark_not_answered
    @status[@curr_question_index][:answer_status] = "skipped"
    increment_question
  end

  def trivia_complete?
    curr_question.nil?
  end
  
  def trivia_incomplete?
    !curr_question.nil?
  end
  
  def has_next_question?
    next_question.nil?
  end  
  
  def curr_question
    trivia.questions[@curr_question_index]
  end
  
  def next_question
    trivia.next_question(curr_question)
  end
  
  def prev_question
    trivia.prev_question(curr_question)
  end
  
  def increment_question
    @curr_question_index = @curr_question_index + 1
  end
  
  def num_complete
    @status.count{|x| x[:answer_status] != "incomplete"}
  end
  
  def num_incomplete
    @status.count{|x| x[:answer_status] == "incomplete"}
  end
  
  def num_incorrect
    @status.count{|x| x[:answer_status] == "incorrect"}
  end
  
  def num_correct
    @status.count{|x| x[:answer_status] == "correct"}
  end
  
  def status_for_question(index)
    @status[index]
  end
  
end 
    