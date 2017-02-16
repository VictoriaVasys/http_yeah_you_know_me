require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/server'

class ServerTest < Minitest::Test

  # test_it_exists leaves the connection open; the rest must be run one at a time, with a new server opened for each test
  
  def test_it_exists
    skip
    server = Server.new
    assert_instance_of Server, server
  end
  
  def test_it_initiates_a_request
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (1) </h1></body></html>", response.body
  end
  
  def test_it_posts_a_response
    skip
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (1) </h1></body></html>", response.body
  end
  
  def test_it_closes_connection
    skip
    response = Faraday.get 'http://localhost:9292/shutdown'
    assert_equal "<html><head></head><body><h1> Total Requests: 1 </h1></body></html>", response.body
  end

end