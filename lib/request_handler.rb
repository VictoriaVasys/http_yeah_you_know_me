
class RequestHandler
  attr_reader :hello_counter, :server_should_exit, :client
  def initialize
    @hello_counter = 0
    @server_should_exit = false
    @client = tcp_server.accept
    @number_of_requests = 0
  end
  
  def accept_request
    puts "Ready for a request"
    request_lines = []
    
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end

    puts "Got this request:"
    puts request_lines.inspect
    find_page(request_lines)
  end

  
  def find_page(request_lines)
    path_id = request_lines[0].split[1]
    return if path_id == '/favicon.ico'
      # client.puts ["http/1.1 404 not-found"]
    if path_id == '/'
      handle_root(request_lines, path_id)
    elsif path_id == '/hello'
      handle_hello
    elsif path_id == '/datetime'
      handle_date_time
    elsif path_id == '/shutdown'
      handle_shut_down
    else 
      "Not a valid path"
    end
    
  end
  
  def handle_root(request_lines, path)
    # Would this be better as a hash?
    verb = request_lines[0].split[0]
    protocol = request_lines[0].split[2]
    host = request_lines[1].split(":")[1].lstrip
    port = request_lines[1].split(":")[2]
    origin = host
    accept = request_lines[-3].split(":")[1].lstrip


    header_string = <<END_OF_HEADERS
    <pre>
      Verb: #{verb}
      Path: #{path}
      Protocol: #{protocol}
      Host: #{host}
      Port: #{port}
      Origin: #{origin}
      Accept: #{accept}
    </pre>
END_OF_HEADERS
  end

  def handle_hello
    @hello_counter += 1
    "<h1> Hello, World! (#{hello_counter}) </h1>"
  end

  def handle_date_time
    "<h1>#{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')}</h1>"
  end

  def handle_shut_down
    @server_should_exit = true  # or just client.close?
    "<h1>Total Requests: #{number_of_requests}</h1>"
  end

  
end