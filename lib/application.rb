require 'registry'
require 'session'

class Application
  @@sessions = Registry.new

  def handle(req, res)
    session = @@sessions.match_session(req)
    session = @@sessions.create_new_session(res) unless session
    session.handle(req, res)
  end

end
