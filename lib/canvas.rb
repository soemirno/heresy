require 'stringio'

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
