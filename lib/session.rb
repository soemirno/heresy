require 'tick_tack_toe'

class Session
  
  def initialize 
    @callbacks = Registry.new 
    @root = TickTackToe.new 
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
