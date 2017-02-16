require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/parse_headers'
require 'socket'

class ParseHeadersTest < Minitest::Test
  
  def test_it_exists
    skip
    ph = ParseHeaders.new("client")
    assert_instance_of ParseHeaders, ph
  end
  
  def test_it_can_parse_the_first_line
    skip
    ph = ParseHeaders.new("client")
    line = "'GET' '/' HTTP/1.1\n"
    ph.top_line(line)
    assert_equal "GET", headers[:verb]
    assert_equal "/", headers[:path]
    assert_equal "HTTP/1.1", headers[:verb]
  end
  
  def test_it_can_parse_the_host_line
    skip
    tcp = TCPServer.new(9292)
    ph = ParseHeaders.new(tcp.accept)
    line = "Host: localhost:9292"
    assert_equal "localhost", headers[:host]
    assert_equal "9292", headers[:port]
  end
  
end