require 'yaml'
require 'puppet'

class Node
  attr_reader :certname, :facts, :node_dir

  def initialize(args)
    @certname    = args[:certname]
    @node_dir    = YamlDir.new(:node_dir => args[:node_dir])
    @facts       = facts_yaml
    @hiera       = args[:hiera] || HieraController.new
  end

  def parameters
    collection = ParameterCollection.new
    facts_yaml.each {|k,v|
      collection << Parameter.new(:key => k, :value => v)}
    collection
  end

  def load_yaml
    path = File.join(@node_dir.path,"#{@certname}.yaml")
    YAML.load_file(path)
  end

  def facts_yaml
    yaml = load_yaml
    yaml.parameters.merge(yaml.facts.values)
  end

  def hiera_values(args = {})
    additive_keys = args[:additive_keys] || []
    @hiera.get_all(:scope => @facts, :additive_keys => additive_keys).
      values.inject({}){|a,v| a.merge!(v)}
  end

  def sorted_values(args = {})
    keys = args[:keys]
    hiera_values(:additive_keys => keys).sort_by{|k,v|k}
  end

  def environment
    @facts['environment']
  end

  def lookup(args)
    @hiera.lookup_additive(:key => args[:key], :scope => @facts)
  end
end
