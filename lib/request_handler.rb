require "./lib/parse_headers"
require "./lib/game"
require "./lib/word_search"

class RequestHandler
  attr_reader :tcp_server, :hello_counter, :close_server, :client, :number_of_requests, :headers, :path, :verb, :game
  def initialize
    @tcp_server = TCPServer.new(9292)
    @hello_counter = 0
    @close_server = false
    @number_of_requests = 0
  end
  
  def accept_request
    puts "Ready for a request"
    @client = tcp_server.accept
    @headers = ParseHeaders.new(client).headers
    @verb = headers[:verb]
    @path = headers[:path]
    puts "Got this request: "
    puts headers
    find_page(path)
  end
  
  def find_page(path)
    unless path == '/favicon.ico'
      @number_of_requests += 1
    end
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
    path == '/start_game' && verb == "POST"
  end
  
  def start_game
    @game = Game.new(rand(100))
    "<h1> Good luck! </h1>"
  end
  
  def play_game?
    path == "/game" && verb == "POST"
  end
  
  def play_game
    game.guesses << client.read(headers[:body_length])
  end
  
  def game_status?
    path == "/game" && verb == "GET"
  end
  
  def handle_root
    "<pre>
      Verb:     #{verb}
      Path:     #{path}
      Protocol: #{headers[:protocol]}
      Host:     #{headers[:host]}
      Port:     #{headers[:port]}
      Origin:   #{headers[:origin]}
      Accept:   #{headers[:accept]}
    </pre>"
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