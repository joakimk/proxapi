require File.join(File.dirname(__FILE__), '../lib/proxapi')
require 'test/unit'
require 'rack/test'
require 'shoulda'
require 'flexmock/test_unit'

set :environment, :test

class ProxApiTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    flexmock(Proxmox).should_receive(:api_key).and_return("testkey")
  end

  def app
    Sinatra::Application
  end

  context "POST /vms" do

    should "create a vm" do
      flexmock(Proxmox).should_receive(:run).once.with("/usr/bin/pvectl vzcreate 101 --disk 8")
      post '/vms', :id => 101, :disk => 8, :api_key => "testkey"
    end
    
    should "not do anything with an invalid api_key" do
      flexmock(Proxmox).should_receive(:run).times(0)
      post '/vms', :id => 101, :disk => 8, :api_key => "invalid"
    end

  end

  context "POST /vms/:id/start" do
    
    should "start the vm" do
      flexmock(Proxmox).should_receive(:run).once.with("/usr/sbin/vzctl start 101")
      post '/vms/101/start', :api_key => "testkey"
    end
    
    should "not do anything with an invalid api_key" do
      flexmock(Proxmox).should_receive(:run).times(0)
      post '/vms/101/start', :api_key => "invalid"
    end
    
  end
  
  context "POST /vms/:id/stop" do
    
    should "stop the vm" do
      flexmock(Proxmox).should_receive(:run).once.with("/usr/sbin/vzctl stop 101 --fast")
      post '/vms/101/stop', :api_key => "testkey"
    end
    
    should "not do anything with an invalid api_key" do
      flexmock(Proxmox).should_receive(:run).times(0)
      post '/vms/101/stop', :api_key => "invalid"
    end    
    
  end  
  
  context "POST /vms/:id/exec" do
    
    should "run a command within the vm" do
      flexmock(Proxmox).should_receive(:run).once.with("/usr/sbin/vzctl exec 101 'ls /tmp'")
      post '/vms/101/exec', :command => "ls /tmp", :api_key => "testkey"
    end
    
    should "not do anything with an invalid api_key" do
      flexmock(Proxmox).should_receive(:run).times(0)
      post '/vms/101/exec', :command => "ls /tmp", :api_key => "invalid"
    end
    
  end
  
  context "DELETE /vms/:id" do
    
    should "delete a vm" do
      flexmock(Proxmox).should_receive(:run).once.with("/usr/sbin/vzctl destroy 101")
      delete '/vms/101', :api_key => "testkey"
    end
    
    should "not do anything with an invalid api_key" do
      flexmock(Proxmox).should_receive(:run).times(0)
      delete '/vms/101', :api_key => "invalid"
    end    
    
  end
  
end