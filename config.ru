require 'app/ui'
require 'sinatra'
require 'tilt'

use Rack::Session::Cookie, :secret => '4zENWx0ruhWU3ZN'

run HieraBrowserUI
