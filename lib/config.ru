require 'app/ui'
require 'sinatra'

use Rack::Session::Cookie, :secret => '4zENWx0ruhWU3ZN'

run Sinatra::Application
