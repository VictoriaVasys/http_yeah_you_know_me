class ParseHeaders 
  attr_reader :client, :headers
  
  def initialize(client)
    @client = client
    parse_headers
  end
  
  def parse_headers
    @headers = {}
    while line = client.gets and !line.chomp.empty?
      top_line(line)           if line.include?("HTTP")
      host_headers(line)       if line.split(":")[0] == "Host"
      origin_header(line)      if line.split(":")[0] == "Origin"
      accept_header(line)      if line.split(":")[0] == "Accept"
      body_length_header(line) if line.split(":")[0] == "Content-Length"
      other_headers(line)      if header_unknown?(line)
    end
  end
  
  def top_line(line)
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
end