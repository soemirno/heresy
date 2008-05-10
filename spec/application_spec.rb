require File.dirname(__FILE__) + '/spec_helper'
require 'application'
require 'webrick'

describe Application, "when handling requests" do

  class Application
    def self.registry=(registry)
      @@sessions = registry
    end
  end

  before(:each) do
    @cookie = mock("cookie")
    @registry = mock("Registry", :register => "new_key", :create_cookie => @cookie)
    @session = mock("session")
    @session.stub!("handle")
    Session.stub!(:new).and_return(@session)
    @cookies = mock("cookies", :detect => nil)
    @cookies.stub!("<<")
    @req = mock("request", :cookies => @cookies)
    @res = mock("response", :cookies => @cookies)
    @session_cookie = mock("session_cookie", :value => "key")
    Application.registry = @registry

    @application = Application.new
  end

  def handle_request
    @application.handle(@req, @res)
  end

  it "should create session if it doesn't exist" do
    Session.should_receive("new").and_return(@session)
    handle_request
  end

  it "should register newly created session" do
    @registry.should_receive("register").with(@session)
    handle_request
  end

  it "should store session id in new cookie" do
    @registry.should_receive("create_cookie").with("heresy","new_key")
    handle_request
  end
  
  it "should store session id to response" do
    @cookies.should_receive("<<").with(@cookie)
    handle_request
  end

  it "shoud retrieve existing session" do
    @cookies.stub!(:detect).and_return(@session_cookie)
    @registry.should_receive("find").with("key")
    handle_request
  end

  it "should let session handle request" do
    @session.should_receive("handle").with(@req, @res)
    handle_request
  end

end