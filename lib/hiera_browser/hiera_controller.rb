require 'yaml'

class HieraController
  attr_reader :hiera_yaml

  def initialize(args={})
    @hiera_yaml = args[:hiera_yaml] || './hiera.yaml'
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
    Hash[*[args[:key],hiera.lookup(args[:key], nil, args[:scope])]]
  end

  def get_all_override(args)
    values = keys.map{|k|
      [k, lookup(:key => k, :scope => args[:scope])]}
    Hash[*values.flatten]
  end
end

