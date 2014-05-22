require 'yaml'

class HieraController
  @@hiera_yaml = ENV['HIERA_YAML'] || './hiera.yaml'
  attr_reader :hiera_yaml

  def initialize(args={})
    @hiera_yaml = args[:hiera_yaml] || @@hiera_yaml
    @hiera = hiera(:config => @hiera_yaml)
  end

  def hiera(args={})
    @hiera || Hiera.new(args)
  end

  def config
    hiera.config
  end

  def datadirs
    config[:backends].map{|b| 
      DataDir.new(:hiera => self, :path => config[b.to_sym][:datadir])}
  end

  def keys
    datadirs.map{|d|
      d.keys}.flatten.uniq.sort
  end

  def hierarchy
    config[:hierarchy]
  end

  def lookup(args)
    key = args[:key]
    scope = args[:scope]
    resolution_type = args[:resolution_type] || :priority
    Hash[*[key,hiera.lookup(key, nil, scope, nil, resolution_type)]]
  end

  def get_all(args)
    scope = args[:scope]
    values = keys.inject({}){|a, k|
      a.merge({k => lookup(:key => k, :scope => scope)}) }
    if args[:additive_keys]
      additive_values = args[:additive_keys].inject({}){|a,k|
        a.merge({k => lookup_additive(:key => k, :scope => scope)}) }
      values = values.delete_if {|k,v| additive_values.has_key?(k)}.merge!(additive_values)
    end
    values
  end

  def lookup_additive(args)
    key = args[:key]
    scope = args[:scope]
    value = lookup(:key => key, :scope => scope)
    lookup_type = 
      case value.values.pop
      when Hash
        :hash
      when TrueClass
        :priority
      when FalseClass
        :priority
      else
        :array
      end
    lookup(:key => key, :scope => scope, :resolution_type => lookup_type)
  end
end

