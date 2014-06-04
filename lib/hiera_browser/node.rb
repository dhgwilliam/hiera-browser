require 'yaml'
require 'puppet'

class Node
  attr_reader :certname, :facts, :node_dir

  @@node_dir = 
    if ENV['YAML_DIR']
      ENV['YAML_DIR']
    elsif File.exist?('/var/opt/lib/pe-puppet/yaml')
      '/var/opt/lib/pe-puppet/yaml/node'
    else
      '/var/lib/puppet/yaml/node'
    end

  def initialize(args)
    @certname    = args[:certname]
    @facts       = facts_yaml
    @hiera       = args[:hiera] || HieraController.new
  end

  def facts_yaml
    path = File.join(@@node_dir,"#{@certname}.yaml")
    node = YAML.load_file(path)
    node.parameters.merge(node.facts.values)
  end

  def hiera_values(args={})
    additive_keys = args[:additive_keys] || []
    @hiera.get_all(:scope => @facts, :additive_keys => additive_keys).
      values.inject({}){|a,v| a.merge!(v)}
  end

  def sorted_values(args)
    keys = args[:keys]
    hiera_values(:additive_keys => keys).sort_by{|k,v|k}
  end

  def environment
    @facts['environment']
  end

  def self.files
    begin
      Dir.chdir(@@node_dir) { Dir.glob('**/*.yaml') }
    rescue Errno::ENOENT => e
      raise "Can't find your $yamldir: #{e}"
    end
  end

  def self.list
    files = self.files
    files.map{|f| f.split('.yaml')}.flatten
  end

  def self.environments
    files = self.files
    files.map{|f|
      YAML.load_file(File.join(@@node_dir,f)).environment.to_s}.uniq
  end

end
