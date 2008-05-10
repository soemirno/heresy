require 'registry'
require 'session'

class Application
  @@sessions = Registry.new

  def handle(req, res)
    session = @@sessions.match_session(req)
    session = @@sessions.create_new_session(res) unless session
    session.handle(req, res)
  end

private

  def create_new_session(res)
    session = Session.new
    session_key = @@sessions.register(session)
    res.cookies << @@sessions.create_cookie("heresy", session_key)
    return session
  end

end
