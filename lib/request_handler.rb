require "./lib/parse_headers"
require "./lib/game"
require "./lib/word_search"

class RequestHandler
  attr_reader :tcp_server, 
              :hello_counter, 
              :close_server, 
              :number_of_requests,
              :game_status,
              :response_code,
              :redirect_path,
              :client, 
              :headers, 
              :path, 
              :verb, 
              :game
              
  def initialize
    @tcp_server = TCPServer.new(9292)
    @hello_counter = 0
    @close_server = false
    @number_of_requests = 0
    @game_status = "Not yet started"
    @response_code = "200 OK"
    @redirect_path = nil
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
    if path == '/'
      root
    elsif path == '/hello' 
      hello
    elsif path == '/datetime'
      date_time
    elsif path.include?('/word_search')
      wordsearch    
    elsif path == '/start_game' && verb == "POST"  
      start_game
    elsif path == "/game" && verb == "POST" && game_status == "Started"
      play_game 
    elsif path == "/game" && verb == "GET"
      @response_code = "200 OK"
      game.report 
    elsif path == '/force_error'
      @response_code = "500 Internal Server Error"
    elsif path == '/shutdown'
      shut_down
    else
      @response_code = "404 Not Found"
    end
  end
  
  def root
    "<pre>
      Verb:     #{verb}
      Path:     #{path}
      Protocol: #{headers[:protocol]}
      Host:     #{headers[:host]}
      Port:     #{headers[:port]}
      Origin:   #{headers[:host]}
      Accept:   #{headers[:accept]}
    </pre>"
  end

  def hello
    @hello_counter += 1
    "<h1> Hello, World! (#{hello_counter}) </h1>"
  end

  def date_time
    "<h1> #{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')} </h1>"
  end
  
  def wordsearch
    word_search = WordSearch.new(path)
    word_search.find_word
  end

  def shut_down
    @close_server = true  # or just client.close?
    "<h1> Total Requests: #{number_of_requests} </h1>"
  end
  
  def start_game
    if @game_status == "Started"
      @response_code = "403 Forbidden"
      @redirect_path = nil
    end
    @game = Game.new(rand(100))
    @game_status = "Started"
    @response_code = "301 Moved Permanently"
    @redirect_path = "http://localhost:9292/game"
  end
  
  def play_game
    request_body = client.read(headers[:body_length].to_i)
    game.guesses << request_body.gsub("\r\n", "").split("guess")[1][1..2].to_i
    @response_code = "302 Moved Permanently"
    @redirect_path = "http://localhost:9292/game"
  end

end