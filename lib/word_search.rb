class WordSearch
  attr_reader :path
  
  def initialize(path)
    @path = path
    find_word
  end
  
  def find_word
    word = path.split("=")[1]
    if dictionary.include?(word)
      "<h1> #{word} is a known word </h1>"
    else
      "<h1> #{word} is not a known word </h1>"
    end  
  end
  
  def dictionary
    File.read("/usr/share/dict/words").split("\n")
  end
end