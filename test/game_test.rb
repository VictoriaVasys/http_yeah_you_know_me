require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/game'

class GameTest < Minitest::Test

  def test_it_exists
    game = Game.new(77)
    assert_instance_of Game, game
  end
  
  def test_it_returns_readable_sentence_for_0_guesses
    game = Game.new(77)
    game.report
  end
  
  def test_it_returns_the_guess_with_readable_sentence_for_1_guess
    game = Game.new(77)
    guesses << 34
    game.report
  end
  
  def test_it_returns_the_guess_with_readable_sentence_for_1_guess
    game = Game.new(77)
    game.guesses << 34
    game.guesses << 93
    game.report
  end
  
  def test_it_knows_if_guess_is_too_high_too_low_or_correct
    game = Game.new(77)
    game.guesses << 34
    game.report
    game.guesses << 99
    game.report
    game.guesses << 77
    game.report
  end
  
end