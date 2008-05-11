require 'webrick'
require 'registry'

class SessionStore
  
  def initialize
    @registry = Registry.new
  end

  def find_or_create_session(request, response)
    session = match_session(request)
    session = create_new_session(response) unless session
    return session
  end
  
  def register(item, response)
    session_key = @registry.register(item)
    response.cookies << create_cookie("heresy", session_key)    
  end

  def create_cookie(name, value)
    WEBrick::Cookie.new(name, value)
  end
  
private  
  def match_session(request)
    session_cookie = request.cookies.detect{|c| c.name == "heresy"}
    session = @registry.find(session_cookie.value) if session_cookie    
  end
  
  def create_new_session(response)
    session = Session.new
    register(session, response)
    return session
  end
  
end
