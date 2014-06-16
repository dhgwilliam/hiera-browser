# A collection of {Parameter}s, based on Arrays
class ParameterCollection
  # @return [void]
  def initialize
    @collection = collection
  end

  # @return [Array]
  def collection
    @collection || []
  end

  def [](index)
    stripped_index = index.sub(/^::/,'')
    collection.select{|param| param.key == stripped_index }.map{|param|param.value}
  end

  # @param parameter [Parameter]
  # @return [ParameterCollection]
  def << (parameter)
    collection << parameter
    dedupe!
    self
  end

  # @return [Array] all keys in this ParameterCollection
  def keys
    collection.map{|param| param.key}.uniq
  end

  # @param param [Parameter]
  # @return [TrueClass, FalseClass] True if this ParameterCollection includes a Parameter
  def include?(param)
    truth = false
    collection.each{|p| truth = true if p == param}
    truth
  end

  # @return [Fixnum] the number of Parameters in the ParameterCollection
  def count
    collection.count
  end

  # @return [Hash] the parameter collection condensed to a Hash, multiple values 
  #   for the same key condensed into an Array, all keys duplicated 
  def to_h
    self.keys.inject({}){|a, k| 
      a[k]        = self[k]
      a[Parameter.top_scope(k)] = self[k]
      a }
  end

  private

  def dedupe!
    @collection = collection.inject([]){|a, param|
      if a.include?(param)
        a
      else
        a << param
      end }
  end
end

# Structured object for holding key/value parameters, whether they are facts or not
class Parameter
  # @param args [Hash{:key => String, :value => Object}]
  # @return [void]
  def initialize(args = {})
    raise ArgumentError, "A Parameter must have both :key and :value" unless
      args[:key] && args[:value]
    @key           = descope(args[:key])
    @value         = args[:value]
  end

  # @return [String] fully qualified {#key}
  #   e.g. `::datacenter`
  def top_scope_key
    Parameter.top_scope(@key)
  end

  # @param param [Parameter]
  # @return [TrueClass, FalseClass]
  def == (param)
    if param.class == Parameter && @key == param.key && @value == param.value
      true
    else
      false
    end
  end

  # @return [String]
  attr_reader :key

  # @return [Object]
  attr_reader :value

  class << self
    # @param key [String]
    # @return [String] the provided key, fully qualified, e.g. "::key"
    def top_scope(key = '')
      "::#{key}"
    end
  end

  private

  # @param key [String] a top-scope variable name / parameter key, e.g. ::key
  # @return [String] the provided key with any top-scoping removed, e.g. key
  def descope(key)
    key.sub(/^::/,'')
  end
end

