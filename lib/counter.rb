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