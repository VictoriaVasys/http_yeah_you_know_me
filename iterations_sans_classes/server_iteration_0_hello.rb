
class HTTP

  def initialize
    require 'socket'
    @tcp_server = TCPServer.new(9292)
    @counter = 1
  end

  puts "Ready for a request"



  def get_request
    while client = tcp_server.accept
      request_lines = []
      
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      puts "Got this request:"
      puts request_lines.inspect
      
      
      # require "pry"; binding.pry
      puts "Sending response."
      response = "<pre>" + "hello world #{counter}" + "</pre>"
      output = "<html><head></head><body>#{response}</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.puts output

      puts ["Wrote this response:", headers, output].join("\n")

      counter += 1
    end

  client.close
  puts "\nResponse complete, exiting."

end