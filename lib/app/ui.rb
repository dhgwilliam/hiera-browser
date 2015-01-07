require 'dotenv'
Dotenv.load

require 'sinatra'
require 'hiera_browser'
require 'ap'
require 'json'
require 'slim'

use Rack::Session::Cookie, :secret => '4zENWx0ruhWU3ZN'

class HieraBrowserUI < Sinatra::Application
  # api
  get '/api/v1/nodes' do
    @nodes = YamlDir.new.node_list
    JSON.generate(@nodes)
  end

  get "/api/v1/node/:node" do |node|
    keys = session[:keys] || []
    @values = Node.new(:certname => node).hiera_values(:additive_keys => keys)
    JSON.generate(@values)
  end

  get "/api/v1/node/:node/additive" do |node|
    keys = Node.new(:certname => node).hiera_values.keys
    @values = Node.new(:certname => node).hiera_values(:additive_keys => keys)
    JSON.generate(@values)
  end

  # human
  get '/' do
    redirect('/nodes')
  end

  get '/nodes' do
    @title = "node list"
    @nodes = YamlDir.new.node_list
    slim :nodes
  end

  get '/node/:node' do |node|
    @title, @node = "node: #{node}", node
    keys = session[:keys] || []
    @values = Node.new(:certname => node).sorted_values(:keys => keys)
    slim :node
  end
end
