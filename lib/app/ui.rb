require 'sinatra'
require 'hiera_browser'
require 'slim'
require 'ap'

get '/' do
  redirect('/nodes')
end

get '/nodes' do
  @nodes = Node.list
  slim :nodes
end

get '/node/:node' do
  @values = Node.new(:certname => params[:node]).hiera_values_override
  slim :node
end
