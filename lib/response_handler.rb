class ResponseHandler
  
  def send_response(page_view, client, verb, response_code, redirect_path)
    puts "Sending response."

    client.puts headers(output(page_view), verb, response_code, redirect_path)
    client.puts output(page_view) if verb == "GET"
    
    puts ["Wrote this response:", headers(output(page_view), verb, response_code, redirect_path), output(page_view)].join("\n")
    puts "\nResponse complete, exiting."
  end
  
  def output(page_view)
    "<html><head></head><body>#{page_view}</body></html>"
  end
  
  def headers(output, verb, response_code, redirect_path)
    if verb == "POST"
      ["HTTP/1.1 #{response_code}",
          "Location: #{redirect_path}",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    else
      ["HTTP/1.1 #{response_code}",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    end
  end          
  
end