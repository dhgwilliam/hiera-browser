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
    @node_dir    = args[:node_dir] || @@node_dir
    @facts       = facts_yaml
    @hiera       = args[:hiera] || HieraController.new
  end

  def parameters(args = {})
    facts_yaml
  end

  def load_yaml
    path = File.join(@node_dir,"#{@certname}.yaml")
    YAML.load_file(path)
  end

  def facts_yaml
    node = load_yaml
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

  class << self
    def files
      begin
        Dir.chdir(@@node_dir) { Dir.glob('**/*.yaml') }
      rescue Errno::ENOENT => e
        raise "Can't find your $yamldir: #{e}"
      end
    end

    def list
      files = self.files
      files.map{|f| f.split('.yaml')}.flatten
    end

    def parameters
      files = self.files
      files.map{|f| YAML.load_file(File.join(@@node_dir,f)).parameters}.
        inject({}){|a,params|
          params.each {|key, value| 
            a[key] = [] unless a[key]
            a[key] << value unless a[key].include? value
          }
          a 
        }
    end

    def environments
      self.parameters["environment"]
    end
  end
end
