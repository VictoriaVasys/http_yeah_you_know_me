class Game
  attr_reader :num
  attr_accessor :guesses
  
  def initialize(num)
    @num = num
    @guesses = []
  end
  
  def report
    current_guess = guesses.last
    if guesses.empty?
      "You've made 0 guesses!"
    else
      "You've made #{guesses.count} #{guess}. \n Your guess was #{current_guess}, which was #{guess_evaluation(current_guess)}."
    end
  end
  
  def guess
    if guesses.count == 1
      "guess"
    else
      "guesses"
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