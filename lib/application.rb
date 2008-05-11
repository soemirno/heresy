require 'session_store'
require 'session'

class Application
  @@sessions = SessionStore.new

  def handle(req, res)
    session = @@sessions.find_or_create_session(req, res)
    session.handle(req, res)
  end

end
