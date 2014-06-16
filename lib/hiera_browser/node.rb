require 'yaml'
require 'puppet'

# A Node represents all that is known about a node in your infrastructure
class Node
  # @return [String] e.g., 'testnode.puppetlabs.com'
  attr_reader :certname
  # @return [Hash] e.g., { 'datacenter' => 'pdx', 'environment' => 'dev' }
  attr_reader :facts
  # @return [YamlDir]
  attr_reader :node_dir


  # @param args [Hash{:certname => String, :node_dir => String}]
  def initialize(args)
    @certname    = args[:certname]
    @node_dir    = YamlDir.new(:node_dir => args[:node_dir])
    @facts       = facts_yaml
    @hiera       = args[:hiera] || HieraController.new
  end

  # @return [ParameterCollection]
  def parameters
    collection = ParameterCollection.new
    facts_yaml.each {|k,v|
      collection << Parameter.new(:key => k, :value => v)}
    collection
  end

  # @return [Hash]
  def load_yaml
    path = File.join(@node_dir.path,"#{@certname}.yaml")
    YAML.load_file(path)
  end

  # @return [Hash] parameters and facts merged from node cache
  def facts_yaml
    yaml = load_yaml
    yaml.parameters.merge(yaml.facts.values)
  end

  # @param args [Hash{:additive_keys => Array}]
  # @return [Hash] all values for all keys, including additive lookups
  #   for any keys included in :additive_keys
  def hiera_values(args = {})
    additive_keys = args[:additive_keys] || []
    @hiera.get_all(:scope => @facts, :additive_keys => additive_keys).
      values.inject({}){|a,v| a.merge!(v)}
  end

  # @param args [{:keys => Array}]
  # @return [Array] flattened collection of all {#hiera_values} sorted alphabetically by key
  #   e.g. [['datacenter', 'pdx'], ['environment', 'dev']]
  def sorted_values(args = {})
    keys = args[:keys]
    hiera_values(:additive_keys => keys).sort_by{|k,v|k}
  end

  # @return [String]
  def environment
    @facts['environment']
  end

  # @param args [Hash{:key => String}]
  # @return [Hash]
  def lookup(args)
    @hiera.lookup_additive(:key => args[:key], :scope => @facts)
  end
end
