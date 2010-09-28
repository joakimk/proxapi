require 'rubygems'
require 'sinatra'

set :port, 3399

class Proxmox
  def self.run(cmd)
    `#{cmd}`
  end
  
  def self.api_key
    File.read("#{ENV['HOME']}/.proxapi.key")
  end
  
  def self.valid_key?(params)
    params[:api_key] == Proxmox.api_key
  end
end

post '/vms' do
  return unless Proxmox.valid_key?(params)
  args = params.find_all { |k, v| ![ 'id', 'api_key' ].include?(k) }.map { |k, v| "--#{k} #{v}" }.join(' ')
  Proxmox.run "/usr/bin/pvectl vzcreate #{params[:id]} #{args}"
end

post '/vms/:id/start' do
  return unless Proxmox.valid_key?(params)
  Proxmox.run "/usr/sbin/vzctl start #{params[:id]}"
end

post '/vms/:id/stop' do
  return unless Proxmox.valid_key?(params)
  Proxmox.run "/usr/sbin/vzctl stop #{params[:id]} --fast"
end

post '/vms/:id/exec' do
  return unless Proxmox.valid_key?(params)
  Proxmox.run "/usr/sbin/vzctl exec #{params[:id]} '#{params[:command]}'"
end

delete '/vms/:id' do
  return unless Proxmox.valid_key?(params)
  Proxmox.run "/usr/sbin/vzctl destroy #{params[:id]}"
end
