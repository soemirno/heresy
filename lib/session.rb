require 'tick_tack_toe'
require 'canvas'
require 'registry'

class Session

  def initialize
    @callbacks = Registry.new
    @root = TickTackToe.new
  end

  def handle(req, res)
    process_request(req)
    build_response(res)
  end

private

  def build_response(response)
    html = Canvas.new(@callbacks)
    @root.render_on(html)
    response.body = html.string
    response["Content-Type"] = "text/html"  
  end
  
  def process_requestx(request)
    request.query.each do |k,v|
      if callback = @callbacks.find(k)
        callback.call(v)
      end
    end    
  end
  
end
