require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/server'

class ServerTest < Minitest::Test

  def test_tcp_server_is_TCP_server
    skip
    server = Server.connect
    server.accept_request
  end
  
  def test_it_increments_counter
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (1) </h1></body></html>", response.body
    
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (2) </h1></body></html>", response.body
  end
  
  def test_it_parses_request_on_root_call
    response = Faraday.get "http://localhost:9292/datetime"
    assert_equal "<html><head></head><body><h1>#{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')}</h1></body></html>", response.body
  end
  
  def test_it_can_find_a_word
    skip
  end

end