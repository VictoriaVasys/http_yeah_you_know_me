require 'socket'
require './lib/request_handler'

class Server
  attr_reader :request_lines, :tcp_server, :request_handler
  
  def initialize
    @tcp_server = TCPServer.new(9292)
    @request_handler = RequestHandler.new
    connect
  end
  
  def connect
    until @server_should_exit ## can we just do until client.close? ... or while tcp is open?
      response = request_handler.accept_request
      require "pry"; binding.pry
      if response
        @number_of_requests += 1
        send_response(response)
      end
    end
    request_handler.client.close
  end

  def send_response(response)
    puts "Sending response."
    
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    request_handler.client.puts headers
    request_handler.client.puts output
    
    puts ["Wrote this response:", headers, output].join("\n")
    
    puts "\nResponse complete, exiting."
  end
  
end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
end