class WordSearch
  attr_reader :path
  
  def initialize(path)
    @path = path
    handle_wordsearch
  end
  
  def handle_wordsearch
    word = path.split("=")[1]
    if dictionary.include?(word)
      "<h1> #{word} is a known word </h1>"
    else
      "<h1> #{word} is a not a known word </h1>"
    end  
  end
  
  def dictionary
    File.read("/usr/share/dict/words").split("\n")
  end
end