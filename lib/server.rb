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
    until request_handler.close_server
      page_view = request_handler.accept_request
      require "pry"; binding.pry
      response_handler.send_response(page_view, request_handler.client)
    end
    request_handler.client.close
  end
end

if __FILE__ == $0
  server = Server.new
end