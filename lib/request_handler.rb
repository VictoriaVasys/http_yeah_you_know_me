require 'socket'
require "./lib/game"
require "./lib/word_search"

class RequestHandler
  attr_reader :tcp_server, :hello_counter, :close_server, :client, :number_of_requests, :headers, :path, :game
  def initialize
    @tcp_server = TCPServer.new(9292)
    @hello_counter = 0
    @close_server = false
    @number_of_requests = 0
  end
  
  def accept_request
    puts "Ready for a request"
    @client = tcp_server.accept
    parse_headers  
    puts "Got this request: "
    puts headers
    find_page(headers[:path])
  end
  
  def parse_headers
    require "pry"; binding.pry
    @headers = {}
    while line = client.gets && !line.chomp.empty?
      # activate_tractor if tractor?(a,b,c)
      # def activate_tractor; vehicle.new(a,b,c) ...not sure if right
      # def tractor?(a,b,c); a + b = c
      
      top_headers(line)        if line.include?("HTTP")
      host_headers(line)       if line.split(":")[0] == "Host"
      origin_header(line)      if line.split(":")[0] == "Origin"
      accept_header(line)      if line.split(":")[0] == "Accept"
      body_length_header(line) if line.split(":")[0] == "Content-Length"
      other_headers(line)      if header_unknown?(line)
    end
  end
  
  def top_headers(line)
    headers[:verb] = line.split[0]
    headers[:path] = line.split[1]
    headers[:protocol] = line.split[2].chomp
  end
  
  def host_headers(line)
    headers[:host] = line.split(":")[1].lstrip
    headers[:port] = line.split(":")[2].chomp
  end
  
  def origin_header(line)
    headers[:origin] = line.split(":")[1].lstrip.chomp
  end
  
  def accept_header(line)
    headers[:accept] = line.split(":")[1].lstrip.chomp
  end
  
  def body_length_header(line)
    headers[:body_length] = line.split(":")[1].lstrip.chomp
  end
  
  def header_unknown?(line)
    line.split(":")[0] != ("Host" || "Origin" || "Accept" || "Content-Length") && !line.include?("HTTP")
  end
  
  def other_headers(line)
    key, value = line.split(":")
    headers[key] = value.chomp
  end
  
  def find_page(path)
    unless path == '/favicon.ico'
      @number_of_requests += 1
    end
    require "pry"; binding.pry
    handle_root          if path == '/'
    handle_hello         if path == '/hello' 
    handle_date_time     if path == '/datetime'
    WordSearch.new(path) if path.include?('/word_search')
    start_game           if start_game?   
    play_game            if play_game?
    game.report          if game_status?
    handle_shut_down     if path == '/shutdown'
  end
  
  def start_game?
    headers[:path] == '/start_game' && headers[:verb] == "POST"
  end
  
  def start_game
    @game = Game.new(rand(100))
    "<h1> Good luck! </h1>"
  end
  
  def play_game?
    headers[:path] == '/game' && headers[:verb] == "POST"
  end
  
  def play_game
    game.guesses << client.read(headers[:body_length])
  end
  
  def game_status?
    headers[:path] == '/game' && headers[:verb] == "GET"
  end
  
  def handle_root
    header_string = <<END_OF_HEADERS
    <pre>
      Verb: #{headers[:verb]}
      Path: #{headers[:path]}
      Protocol: #{headers[:protocol]}
      Host: #{headers[:host]}
      Port: #{headers[:port]}
      Origin: #{headers[:origin]}
      Accept: #{headers[:accept]}
    </pre>
END_OF_HEADERS
  end

  def handle_hello
    @hello_counter += 1
    "<h1> Hello, World! (#{hello_counter}) </h1>"
  end

  def handle_date_time
    "<h1> #{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')} </h1>"
  end

  def handle_shut_down
    @close_server = true  # or just client.close?
    "<h1> Total Requests: #{number_of_requests} </h1>"
  end

end