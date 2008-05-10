require 'registry'
require 'session'

class Application
  @@sessions = Registry.new

  def handle(req, res)
    session = find_existing_sesion(req)
    session = create_new_session(res) unless session
    session.handle(req, res)
  end

private
  def find_existing_sesion(req)
    session_cookie = req.cookies.detect{|c| c.name == "heresy"}
    session = @@sessions.find(session_cookie.value) if session_cookie
  end

  def create_new_session(res)
    session = Session.new
    session_key = @@sessions.register(session)
    res.cookies << create_cookie("heresy", session_key)
    return session
  end

  def create_cookie(name, key)
    WEBrick::Cookie.new(name, key)
  end

end
