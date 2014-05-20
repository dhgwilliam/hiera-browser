require 'sinatra'
require 'hiera_browser'
require 'ap'
require 'json'
require 'slim'

class HieraBrowserUI < Sinatra::Application
  # api
  get '/api/v1/nodes' do
    @nodes = Node.list
    JSON.generate(@nodes)
  end

  get "/api/v1/node/:node" do |node|
    keys = session[:keys] || []
    @values = Node.new(:certname => node).sorted_values(:keys => keys)
    JSON.generate(@values)
  end

  post "/api/v1/node/:node" do |node|
    keys = JSON.instance_eval(request['keys']) || []
    @values = Node.new(:certname => node).sorted_values(:keys => keys)
    JSON.generate(@values)
  end

  # human
  get '/' do
    redirect('/nodes')
  end

  get '/nodes' do
    @title = "node list"
    @nodes = Node.list
    slim :nodes
  end

  get '/node/:node' do |node|
    @title, @node = "node: #{node}", node
    keys = session[:keys] || []
    @values = Node.new(:certname => node).sorted_values(:keys => keys)
    slim :node
  end

  get '/add/additive/:key' do |key|
    session[:keys] = session[:keys] || []
    session[:keys] << key
    redirect back
  end

  get '/remove/additive/:key' do |key|
    session[:keys].reject!{|k| k == key}
    redirect back
  end

  get '/debug/session' do
    JSON.generate(session[:keys])
  end
end
