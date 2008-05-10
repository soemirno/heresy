require 'counter'

class MultiCounter
  def initialize
    @counters = [Counter.new, Counter.new, Counter.new]
  end
  
  def render_on(html)
    @counters.each{|ea| ea.render_on(html)}
  end
end