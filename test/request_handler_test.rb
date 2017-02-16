require 'minitest/autorun'
require 'faraday'
require './lib/request_handler'

class RequestHandlerTest < Minitest::Test
  
  def test_it_exists
    rh = RequestHandler.new
    assert_instance_of RequestHandler, rh
  end
  
  def test_it_displays_headers_on_root_call
    response = Faraday.get 'http://localhost:9292/'
    assert_equal "<html><head></head><body><h1><pre>......... </pre></h1></body></html>", response.body
  end
  
  def test_it_increments_hello_counter
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (1) </h1></body></html>", response.body
    
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal "<html><head></head><body><h1> Hello, World! (2) </h1></body></html>", response.body
  end
  
  def test_it_displays_current_time
    response = Faraday.get "http://localhost:9292/datetime"
    assert_equal "<html><head></head><body><h1>#{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')}</h1></body></html>", response.body
  end
  
end