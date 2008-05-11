require File.dirname(__FILE__) + '/spec_helper'

require 'session'

describe Session, "when first request" do
  
  class Session
    attr_writer :root, :callbacks
  end
  
  before(:each) do
    @callback = mock("callback", :call => nil)
    @canvas = mock("canvas", :string => "some content")
    @component = mock("component", :render_on => nil)
    @registry = mock("registry", :find => @callback)
    @request = mock("request", :query => {"key_1" => "value_1", "key_2" => "value_2"})
    @response = mock("response", :body= => nil, :[]= => nil)
    
    Canvas.stub!(:new).and_return(@canvas)
    
    @session = Session.new
    @session.root = @component
    @session.callbacks = @registry
  end
  
  def handle
    @session.handle(@request, @response)
  end
  
  it "should initialse canvas with callbacks reference" do
    Canvas.should_receive(:new).with(@registry).and_return(@canvas)
    handle
  end
  
  it "should let component render on canvas" do
    @component.should_receive(:render_on).with(@canvas)
    handle
  end
  
  it "should search in registry for callback" do
    @registry.should_receive(:find).with("key_2").and_return(@callback)
    @callback.should_receive(:call).with("value_2")
    handle
  end
  
  it "should query request" do
    @request.should_receive(:query).and_return([])
    handle
  end
  
  it "should give content-type to response" do
    @response.should_receive(:[]=).with("Content-Type","text/html")
    handle
  end

  it "should give body to response" do
    @response.should_receive(:body=).with("some content")
    handle
  end

end