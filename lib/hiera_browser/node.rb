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

  def hiera_values_override
    @hiera.get_all_override(:scope => facts_yaml)
  end

  def self.list
    files = Dir.new(@@node_dir).select{|f|
      f.match(/^[^\.]\w+\.yaml/)}
    files.map{|f| f.split('.yaml')}.flatten
  end
end
