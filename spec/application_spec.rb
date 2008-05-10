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

    @session = mock("session")
    @session.stub!("handle")
    @registry = mock("Registry", :match_session => nil, :create_new_session => @session)

    @req = mock("request")
    @res = mock("response")
    @session_cookie = mock("session_cookie", :value => "key")

    Application.registry = @registry
    @application = Application.new
  end

  def handle_request
    @application.handle(@req, @res)
  end

  it "shoud create session if not exist" do
    @registry.should_receive("create_new_session").with(@res).and_return(@session)
    handle_request
  end

  it "shoud match session to request if exist" do
    @registry.should_receive("match_session").with(@req).and_return(@session)
    @registry.should_not_receive("create_new_session")
    handle_request
  end

  it "should let session handle request" do
    @session.should_receive("handle").with(@req, @res)
    handle_request
  end

end