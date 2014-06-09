require 'yaml'

class DataDir
  attr_reader :path

  # @return [void]
  def initialize(args={})
    @hiera = args[:hiera]
    @paths = render_paths(:path => args[:path])
  end

  # @return [Array]
  def render_paths(args)
    begin
      variables = args[:path].match(/\%\{([a-z_\:]+)\}/).captures
      variables.map{|v|
        Node.parameters[v].map{|param|
          args[:path].gsub(/\%\{#{v}\}/, param)}.flatten
      }.flatten
    rescue NoMethodError
      [args[:path]]
    end
  end

  # @return [Array]
  def yaml_files
    @paths.map{|p|
      Dir.chdir(p) { Dir.glob('**/*.yaml') }
    }.flatten
  end

  # @return [Array]
  def datafiles
    @paths.map{|path|
      yaml_files.map{|f| DataFile.new(:path => File.join(path,f))}.flatten
    }.flatten
  end

  # @return [Array]
  def keys
    datafiles.map{|datafile| datafile.keys}.flatten.uniq.sort
  end
end

class DataFile
  attr_reader :path

  # @return [void]
  def initialize(args={})
    @path = args[:path]
    @keys = keys
  end

  # @return [Array]
  def keys
    YAML.load_file(@path).keys
  end
end
