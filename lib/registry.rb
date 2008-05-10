require 'webrick'

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
  
  def create_cookie(name, value)
    WEBrick::Cookie.new(name, value)
  end
end
