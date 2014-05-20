require 'lookout/rack/test/rake'

desc "demo environment"
task :demo do
  ENV['HIERA_YAML'] = './spec/fixtures/hiera.yaml'
  ENV['YAML_DIR'] = './spec/fixtures/yaml/node'
  exec('bundle exec shotgun -Ilib -s puma')
end
