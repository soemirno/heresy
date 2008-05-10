require 'stringio'
require 'registry'
require 'canvas'
require 'session'

class Application
  @@sessions = Registry.new
  
  def handle(req, res)
    session_cookie = req.cookies.detect{|c| c.name == "heresy"}
    if(session_cookie)
      session = @@sessions.find(session_cookie.value)
    end
    
    unless session
      session = Session.new
      res.cookies << WEBrick::Cookie.new("heresy", @@sessions.register(session))
    end
    
    session.handle(req, res)
  end
end 
