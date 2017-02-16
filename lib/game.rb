class Game
  attr_reader :num
  
  def initialize(num)
    @num = num
  end
  
  def guesses
    []
  end
  
  def report
    current_guess = guesses.last
    if guesses.empty?
      "You've made 0 guesses!"
    else
      "You've made #{guesses.count} guesses! Your guess was #{current_guess}, which was #{guess_evaluation(current_guess)}"
    end
  end
  
  def guess_evaluation(current_guess)
    if current_guess == num
      "correct"
    elsif current_guess < num 
      "too low"
    else
      "too high"
    end
  end
  
end