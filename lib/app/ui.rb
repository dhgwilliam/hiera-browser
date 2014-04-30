require 'sinatra'
require 'hiera_browser'
require 'slim'
require 'ap'

enable :sessions

get '/' do
  redirect('/nodes')
end

get '/nodes' do
  @nodes = Node.list
  slim :nodes
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
