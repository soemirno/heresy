require File.dirname(__FILE__) + '/spec_helper'
require 'canvas'

describe Canvas, "when building tag" do

  before(:each) do
    @html = Canvas.new(nil)
  end

  it "should build tag with attributes" do
    @html.tag("p", {:class => "classname"} ){}
    @html.string.should == "<p class='classname'></p>"
  end
  
  it "should build tag in tag" do
    @html.tag("table"){
      @html.tag("tr"){}
    }
    @html.string.should == "<table><tr></tr></table>"
  end

end

describe Canvas, "when creating link" do

  before(:each) do
    @callbacks = mock("callbacks", :register => "1234")
    @html = Canvas.new(@callbacks)
    @call = Proc.new {}
  end

  it "should create reference with link to call" do    
    @html.link("reference"){}
    @html.string.should == "<a href='?1234'>reference</a>"
  end
  
  it "should register call" do
    @callbacks.should_receive(:register).with(@call)
    @html.link("reference", &@call)
  end
  
end