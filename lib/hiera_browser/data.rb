require 'yaml'

class DataDir
  attr_reader :path

  def initialize(args={})
    @environment = args[:environment] || 'production'
    @hiera = args[:hiera]
    @path = args[:path].gsub(/\%\{.*\}/, @environment)
  end

  def yaml_files
    Dir.chdir(@path) { Dir.glob('**/*.yaml') }
  end

  def datafiles
    yaml_files.map{|f| DataFile.new(:path => File.join(@path,f))}.flatten
  end

  def keys
    datafiles.map{|datafile| datafile.keys}.flatten.uniq.sort
  end
end

class DataFile
  attr_reader :path

  def initialize(args={})
    @environment = args[:environment] || 'production'
    @path = args[:path].gsub(/\%\{.*\}/, @environment)
    @keys = keys
  end

  def keys
    YAML.load_file(@path).keys
  end
end
