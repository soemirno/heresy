require 'webrick' 
require 'stringio' 
server = WEBrick::HTTPServer.new(:Port => 2000) 
server.mount_proc("/heresy"){|req, res| Application.new.handle(req, res)} 
server.mount_proc("/favicon.ico"){|req,res| res.status = 404} 

class Application   
    def handle(req, res) 
        canvas = Canvas.new(res) 
        render_on(canvas) 
    end 
    
    def render_on(html) 
        html.heading("Hello World") 
    end 
end 
  
class Canvas 
  
  def initialize(res)
    @res = res
    res['Content-Type'] = 'text/html'
  end
  
  def heading(str, level=1) 
    @res.body = "<h1>"+ str + "</h1>"
  end 
  
end

trap("INT"){ server.shutdown } 
server.start