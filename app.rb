require 'webrick' 
require 'stringio' 
server = WEBrick::HTTPServer.new(:Port => 2000) 
server.mount_proc("/heresy"){|req, res| Application.new.handle(req, res)} 
server.mount_proc("/favicon.ico"){|req,res| res.status = 404} 

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
end

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
  
class Canvas 
  def initialize(cbs)
    @io = StringIO.new
    @callbacks = cbs
  end
  
  def tag(name, attrs = {}, &proc)
    @io << "<"
    @io << name
    attrs.each{|k,v| @io << " #{k}='#{v}'"}
    @io << ">"
    proc.call
    @io << "</#{name}>"
  end
  
  def text(str)
    @io << str
  end
  
  def link(name, &proc)
    id = @callbacks.register(proc)
    tag("a", { :href=>"?#{id}"} ) { text(name) }
  end
      
  def space
    @io << " "
  end
        
  def heading(txt, level = 1)
    tag("h#{level}"){text(txt)}
  end
  
  def string
    @io.string
  end
end

class MultiCounter
  def initialize
    @counters = [Counter.new, Counter.new, Counter.new]
  end
  
  def render_on(html)
    @counters.each{|ea| ea.render_on(html)}
  end
end

class Counter 
  def initialize
    @count = 0 
  end 
  
  def render_on(html) 
    html.heading("Hello World: #{@count}") 
    html.tag("p"){html.text("this is fun!!!")}
    html.link("--"){ @count -= 1 } 
    html.space 
    html.link("++"){ @count += 1 } 
  end 
end

class Session
  
  def initialize 
    @callbacks = Registry.new 
    @root = MultiCounter.new 
  end 
  
  def handle(req, res)    
    req.query.each do |k,v|
      if callback = @callbacks.find(k)
        callback.call(v)
      end
    end

    html = Canvas.new(@callbacks)
    @root.render_on(html)
    
    res.body = html.string
    res["Content-Type"] = "text/html"
  end
end

trap("INT"){ server.shutdown } 
server.start