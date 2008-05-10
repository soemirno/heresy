require 'webrick'

class Registry
  def initialize
    @items = []
  end

  def register(item)
    @items << item
    (@items.size - 1).to_s
  end

  def find(key)
    @items[key.to_i]
  end
  
  def create_cookie(name, value)
    WEBrick::Cookie.new(name, value)
  end
  
  def match_session(request)
    session_cookie = request.cookies.detect{|c| c.name == "heresy"}
    session = find(session_cookie.value) if session_cookie    
  end
  
  def create_new_session(response)
    session = Session.new
    session_key = register(session)
    response.cookies << create_cookie("heresy", session_key)
  end
end
