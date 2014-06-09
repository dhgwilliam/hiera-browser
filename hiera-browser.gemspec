Gem::Specification.new do |s|
  s.name = 'hiera-browser'
  s.version = '1.2.2'
  s.licenses = ['APACHE 2.0']
  s.summary = 'Naive browser for hiera data'
  s.description = 'Tries to guess what values hiera will return for any existing node in your infrastructure'
  s.authors = ['David Gwilliam']
  s.email = 'dhgwilliam@gmail.com'
  s.files = Dir['bin/hiera-browser','config.ru', 'lib/**/*.rb', 'lib/**/*.slim']
  s.executables << 'hiera-browser'
  s.bindir = 'bin'
  s.add_runtime_dependency 'hiera', '1.3.2'
  s.add_runtime_dependency 'sinatra', '~> 1.4.5'
  s.add_runtime_dependency 'slim'
  s.add_runtime_dependency 'awesome_print', '1.2.0'
  s.add_runtime_dependency 'tilt', '1.4.1'
  s.add_runtime_dependency 'dotenv'
  s.add_development_dependency 'puma', '~> 2.8.2'
  s.add_development_dependency 'puppet', '~> 3'
  s.add_development_dependency 'pry', '0.9.12.6'
  s.add_development_dependency 'pry-doc'
  s.add_development_dependency 'shotgun'
  s.add_development_dependency 'lookout-rack-test'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
end
