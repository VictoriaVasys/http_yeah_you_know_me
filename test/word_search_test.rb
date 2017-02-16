require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/word_search'

class WordSearchTest < Minitest::Test

  def test_it_exists
    ws = WordSearch.new("/word_search?word=dog")
    assert_instance_of WordSearch, ws
  end
  
  def test_the_dictionary_is_split_into_readable_words
    ws = WordSearch.new("/word_search?word=dog")
    assert_equal "A", ws.dictionary[0]
  end
  
  def test_it_can_find_valid_word
    response = Faraday.get 'http://localhost:9292/word_search?word=dog'
    assert_equal "<html><head></head><body><h1> dog is a known word </h1></body></html>", response.body
  end

  def test_it_can_find_invalid_word
    response = Faraday.get 'http://localhost:9292/word_search?word=doggyjjij'
    assert_equal "<html><head></head><body><h1> doggyjjij is not a known word </h1></body></html>", response.body
  end

end