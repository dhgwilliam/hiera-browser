require 'yaml'

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
