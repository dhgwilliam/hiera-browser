require 'sinatra'
require 'hiera_browser'
require 'ap'
require 'json'
require 'slim'

get '/' do
  redirect('/nodes')
end

get '/nodes' do
  @nodes = Node.list
  slim :nodes
end

get '/api/v1/nodes' do
  @nodes = Node.list
  JSON.generate(@nodes)
end

get "/api/v1/node/:node" do
  keys = session[:keys] || []
  @values = Node.new(:certname => params[:node]).hiera_values(:additive_keys => keys).sort_by{|k,v|v.keys.pop}
  JSON.generate(@values)
end

get '/node/:node' do
  keys = session[:keys] || []
  @values = Node.new(:certname => params[:node]).hiera_values(:additive_keys => keys).sort_by{|k,v|v.keys.pop}
  slim :node
end

get '/add/additive/:key' do
  session[:keys] = Array.new unless session[:keys]
  session[:keys] << params[:key]
  redirect back
end

get '/remove/additive/:key' do
  session[:keys].reject!{|key| key == params[:key]}
  redirect back
end
