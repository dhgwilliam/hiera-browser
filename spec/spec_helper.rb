require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

$fixtures_path = File.join(File.dirname(__FILE__), 'fixtures')

ENV['YAML_DIR'] ||= File.join($fixtures_path, 'yaml/node')
ENV['HIERA_YAML'] ||= File.join($fixtures_path, 'hiera_clean.yaml')

require 'rspec'
require 'hiera_browser'
