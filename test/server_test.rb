require 'minitest/autorun'
require 'faraday'
require './lib/server'

class ServerTest < Minitest::Test

  def test_tcp_server_is_TCP_server
    skip
    server = Server.new
    server.accept_request
    
  end
  
  def test_it_increments_counter
    # server = Server.new
    # server.connect
    
    response = Faraday.get 'http://google.com'
    assert_equal "<html><head></head><body><h1> Hello, World! (1) </></body></html>", response.body
    
    response = Faraday.get 'http://google.com'
    assert_equal "<html><head></head><body><h1> Hello, World! (2) </></body></html>", response.body
    
  end
  
  def test_it_parses_request_on_root_call
    skip
    server = Server.new
    server.connect
    response = Faraday.get "http://127.0.0.1:9292/"
    assert_equal 9, server.request_lines.count
  end

end