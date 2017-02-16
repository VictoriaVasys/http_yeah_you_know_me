require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/request_handler'

class RequestHandlerTest < Minitest::Test
  
  def test_it_exists
    rh = RequestHandler.new
    assert_instance_of RequestHandler, rh
  end
  
  def test_it_displays_headers_on_root_call
    response = Faraday.get 'http://localhost:9292/'
    assert_equal "<html><head></head><body><pre>
      Verb:     GET
      Path:     /
      Protocol: HTTP/1.1
      Host:     localhost
      Port:     9292
      Origin:   localhost
      Accept:   */*
    </pre></body></html>", response.body
  end
  
  def test_it_increments_hello_counter
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (1) </h1></body></html>", response.body
    
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (2) </h1></body></html>", response.body
  end
  
  def test_it_displays_current_time
    response = Faraday.get "http://localhost:9292/datetime"
    assert_equal "<html><head></head><body><h1> #{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')} </h1></body></html>", response.body
  end
  
  def test_it_finds_words_from_dictionary
    response = Faraday.get "http://localhost:9292/word_search?word=cat"
    assert_equal "<html><head></head><body><h1> cat is a known word </h1></body></html>", response.body
  end
  
  def test_game_returns_information_about_guesses
    skip
    response = Faraday.post 'http://localhost:9292/start_game'
    assert_equal "<html><head></head><body><h1>You've made 0 guesses!</h1></body></html>", response.body
    response = Faraday.post "http://localhost:9292/game", { :guess => 42 }
    assert_equal "<html><head></head><body><h1>You've made 1 guess.
 Your guess was 42, which was too high.</h1></body></html>", response.body
  end
  
  def test_it_returns_total_requests_on_shutdown
    skip
    response = Faraday.get "http://localhost:9292/shutdown"
    assert_equal "<html><head></head><body><h1> Total Requests: 8 </h1></body></html>", response.body
  end
  
end