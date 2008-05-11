require 'webrick'

class Registry
  
  def initialize
    @items = []
  end

  def find_or_create_session(request, response)
    session = match_session(request)
    session = create_new_session(response) unless session
    return session
  end
  
  def register(item, response)
    @items << item
    session_key = (@items.size - 1).to_s
    response.cookies << create_cookie("heresy", session_key)    
  end

  def find(key)
    @items[key.to_i]
  end
  
  def create_cookie(name, value)
    WEBrick::Cookie.new(name, value)
  end
  
private  
  def match_session(request)
    session_cookie = request.cookies.detect{|c| c.name == "heresy"}
    session = find(session_cookie.value) if session_cookie    
  end
  
  def create_new_session(response)
    session = Session.new
    register(session, response)
    return session
  end
  
end
