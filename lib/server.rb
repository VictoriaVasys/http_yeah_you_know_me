require 'socket'
require './lib/request_handler'
require "./lib/response_handler"

class Server
  attr_reader :request_handler, :response_handler
  
  def initialize
    @request_handler = RequestHandler.new
    @response_handler = ResponseHandler.new
    connect
  end
  
  def connect
    until request_handler.close_server ## can we just do until client.close? ... or while tcp is open?
      page_view = request_handler.accept_request
      # require "pry"; binding.pry
      if page_view
        response_handler.send_response(page_view, request_handler.client)
      end
    end
    request_handler.client.close
  end
end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
end