class ParameterCollection
  def initialize
    @collection = collection
  end

  def collection
    @collection || []
  end

  def [](index)
    stripped_index = index.sub(/^::/,'')
    collection.select{|param| param.key == stripped_index }.map{|param|param.value}
  end

  def << (parameter)
    collection << parameter
    dedupe!
    self
  end

  def keys
    collection.map{|param| param.key}.uniq
  end

  def include?(param)
    truth = false
    collection.each{|p| truth = true if p == param}
    truth
  end

  def count
    collection.count
  end

  def to_h
    self.keys.inject({}){|a, k| 
      a[k]        = self[k]
      a["::#{k}"] = self[k]
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

class Parameter
  attr_reader :key, :value

  def initialize(args = {})
    raise ArgumentError, "A Parameter must have both :key and :value" unless
      args[:key] && args[:value]
    @key           = descope(args[:key])
    @value         = args[:value]
  end

  def top_scope_key
    "::#{@key}"
  end

  def == (param)
    if param.class == Parameter && @key == param.key && @value == param.value
      true
    else
      false
    end
  end

  private

  def descope(key)
    key.sub(/^::/,'')
  end
end

