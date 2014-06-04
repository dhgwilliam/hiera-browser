require 'lookout/rack/test/cucumber'

ENV['HIERA_YAML'] = ENV['HIERA_YAML'] ||  'spec/fixtures/hiera_clean.yaml'
ENV['YAML_DIR'] = 'spec/fixtures/yaml/node'

require 'app/ui'
set :show_exceptions, false
Lookout::Rack::Test.app = HieraBrowserUI
require 'lookout/rack/test/cucumber/server'
require 'lookout/rack/test/cucumber/transforms'


