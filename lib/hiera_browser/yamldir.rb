require 'puppet'

# YamlDir allows you to retrieve information from Puppet's node cache
class YamlDir
  @@node_dir = 
    if ENV['YAML_DIR']
      ENV['YAML_DIR']
    elsif File.directory?('/var/opt/lib/pe-puppet/yaml')
      '/var/opt/lib/pe-puppet/yaml/node'
    else
      '/var/lib/puppet/yaml/node'
    end

  def initialize(args = {})
    @node_dir    = args[:node_dir] || @@node_dir
    raise Exception.new "Can't find your $yamldir: #{@node_dir}" unless File.directory?(@node_dir)
  end

  def path
    @node_dir
  end

  def file_list
    Dir.chdir(@node_dir) { Dir.glob('**/*.yaml') }
  end

  def node_list
    file_list.map{|f| f.split('.yaml')}.flatten
  end

  def load_files
    file_list.map{|f| YAML.load_file(File.join(@node_dir,f))}
  end

  # @note #parameters is provided for temporary backwards compatibility
  # @see #collected_parameters
  def parameters
    collected_parameters_hash
  end

  # @note #collected_parameters is preferred over #parameters
  def collected_parameters
    collection = ParameterCollection.new
    load_files.map{|f| f.parameters}.
      each{|params| params.each {|key, value| 
          collection << Parameter.new(:key => key, :value => value) } }
    collection
  end

  def collected_parameters_hash
    collected_parameters.to_h
  end

  def environments
    collected_parameters["environment"]
  end
end

