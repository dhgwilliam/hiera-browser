require 'dotenv'
Dotenv.load

require 'sinatra'
require 'hiera_browser'
require 'ap'
require 'json'
require 'slim'

class HieraBrowserUI < Sinatra::Application
  # api
  get '/api/v1/nodes' do
    @nodes = YamlDir.new.node_list
    JSON.generate(@nodes)
  end

  get "/api/v1/node/:node" do |node|
    node = Node.new(:certname => node)
    if params[:overrides]
      params[:overrides].each do |fact|
        node.facts[fact[1]['key']] = fact[1]['value']
      end
    end
    @additive_keys = node.hiera_values.keys unless params[:additive] == 'false'
    @values = node.hiera_values(:additive_keys => @additive_keys).to_json
  end

  # human
  get '/' do
    redirect('/nodes')
  end

  get '/nodes' do
    @title = "node list"
    @nodes = YamlDir.new.node_list
    erb :nodes
  end
end
