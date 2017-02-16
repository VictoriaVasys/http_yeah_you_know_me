require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/response_handler'

class ResponseHandlerTest < Minitest::Test

  def test_it_exists
    rh = ResponseHandler.new
    assert_instance_of ResponseHandler, rh
  end
  
  def test_it_outputs_correct_browser_display
    rh = ResponseHandler.new
    output = rh.output("<h1> cat is a known word </h1>")
    assert_equal "<html><head></head><body><h1> cat is a known word </h1></body></html>", output
  end
  
  def test_posts_correct_response_headers_for_get_requeest
    rh = ResponseHandler.new
    response = rh.headers("<h1> Hello, World! (1) </h1>", "GET", "200 OK", nil)
    expected_response = "HTTP/1.1 200 OK\r\ndate: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r\nserver: ruby\r\ncontent-type: text/html; charset=iso-8859-1\r\ncontent-length: 28\r\n\r\n"
    
    assert_equal expected_response, response
  end

end