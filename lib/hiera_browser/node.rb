require 'yaml'
require 'puppet'

class Node
  attr_reader :certname, :facts, :node_dir

  @@node_dir = 
    begin
      File.join(Puppet[:yamldir],'node')
    rescue Puppet::Settings::InterpolationError
      Puppet.initialize_settings_for_run_mode(:master)
      File.join(Puppet[:yamldir],'node')
    end

  def initialize(args)
    @certname = args[:certname]
    @facts = facts_yaml
    @hiera = args[:hiera] || HieraController.new
  end

  def facts_yaml
    YAML.load_file(File.join(@@node_dir,"#{@certname}.yaml")).facts.values
  end

  def hiera_values(args={})
    additive_keys = args[:additive_keys] || []
    @hiera.get_all(:scope => facts_yaml, :additive_keys => additive_keys)
  end

  def self.list
    files = Dir.chdir(@@node_dir) do
      Dir.glob('**/*.yaml')
    end
    files.map{|f| f.split('.yaml')}.flatten
  end
end
