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
end
      
class DataDir
  attr_reader :path

  def initialize(args={})
    @hiera = args[:hiera]
    @path = args[:path]
  end

  def yaml_files
    dir = Dir.new(@path)
    dir.select{|filename| filename.match(/^[^\.]\w+\.yaml/)}
  end

  def datafiles
    yaml_files.map{|f| 
      DataFile.new(:path => File.join(@path,f))}.flatten
  end

  def keys
    datafiles.map{|datafile|
      datafile.keys}.flatten.uniq.sort
  end
end

class DataFile
  attr_reader :path

  def initialize(args={})
    @path = args[:path]
    @keys = keys
  end

  def keys
    YAML.load_file(@path).keys
  end
end

class Node
  def initialize(args)
  end

  def self.list
  end
end
