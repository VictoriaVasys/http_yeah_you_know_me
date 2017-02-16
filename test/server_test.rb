require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/server'

class ServerTest < Minitest::Test

  def test_it_exists
    server = Server.new
    assert_instance_of Server, server
  end
  
  def test_it_initiates_a_request
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (1) </h1></body></html>", response.body
  end
  
  def test_it_posts_a_response
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (1) </h1></body></html>", response.body
  end
  
  def test_it_closes_connection
    response = Faraday.get 'http://localhost:9292/shutdown'
    assert_equal "<html><head></head><body><h1> Total Requests: 1 </h1></body></html>", response.body
  end

end