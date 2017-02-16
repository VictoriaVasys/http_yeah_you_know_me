require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/response_handler'

class ResponseHandlerTest < Minitest::Test

  def test_it_exists
    rh = ResponseHandler
    assert_instance_of ResponseHandler, rh
  end
  
  def method_name
    
  end

end