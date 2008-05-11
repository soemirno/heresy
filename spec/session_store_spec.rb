require File.dirname(__FILE__) + '/spec_helper'
require 'session_store'
require 'session'

describe SessionStore, "when looking up sessions" do

  before(:each) do
    @registry = SessionStore.new
    @item_1 = mock("item 1")
    @item_2 = mock("item 2")

    @cookie = mock("cookie", :value => "1")
    @cookies = mock("cookies", :<< => nil)

    @response = mock("response", :cookies => @cookies)
    @request = mock("request", :cookies => @cookies)

    @registry.register(@item_1, @response)
    @registry.register(@item_2, @response)
    
    Session.stub!(:new).and_return(mock("Session"))
  end

  def find
    @cookies.stub!(:detect).and_return(@cookie)    
    @session = @registry.find_or_create_session(@request, @response)
  end

  def create
    @cookies.stub!(:detect).and_return(nil)
    @session = @registry.find_or_create_session(@request, @response)
  end

  it "should find or create" do
    find
    @session.should == @item_2
  end

  it "should create new session if not exist" do
    Session.should_receive(:new).and_return(@session)
    create
  end

  it "should put session reference in response" do
    @cookies.should_receive("<<")
    create
  end

end

describe SessionStore, "when creating cookie" do

  before(:each) do
    @registry = SessionStore.new
  end

  def create_cookie
    @cookie = @registry.create_cookie("a name", "value")
  end

  it "should store name in cookie" do
    create_cookie
    @cookie.name.should == "a name"
  end

  it "should store value in cookie" do
    create_cookie
    @cookie.value.should == "value"
  end

end