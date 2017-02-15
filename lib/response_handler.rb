class ResponseHandler
  
  def send_response(page_view, client)
    puts "Sending response."

    client.puts headers(output(page_view))
    client.puts output(page_view)
    
    puts ["Wrote this response:", headers(output(page_view)), output(page_view)].join("\n")
    puts "\nResponse complete, exiting."
  end
  
  def output(page_view)
    "<html><head></head><body>#{page_view}</body></html>"
  end
  
  def headers(output)
    ["http/1.1 200 ok",
        "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
        "server: ruby",
        "content-type: text/html; charset=iso-8859-1",
        "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end
              
  
end