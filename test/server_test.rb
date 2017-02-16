require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/server'

class ServerTest < Minitest::Test

  def test_it_exists
    server = Server.connect
    assert_instance_of Server, server
  end
  

  
  def test_it_can_find_a_word
    skip
  end

end