$: << File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'webrick'
require 'application'

server = WEBrick::HTTPServer.new(:Port => 2000) 
server.mount_proc("/heresy"){|req, res| Application.new.handle(req, res)} 
server.mount_proc("/favicon.ico"){|req,res| res.status = 404} 
trap("INT"){ server.shutdown } 
server.start