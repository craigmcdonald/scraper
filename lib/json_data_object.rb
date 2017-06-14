require 'json'

class JsonDataObject

  def initialize(str)
    @data = keys_to_snake_case(JSON.parse(str))
  end

  def keys
    nested_keys
  end

  def has_key?(key)
    nested_keys.include?(key)
  end

  def [](key)
    nested_value(key)[0] if has_key?(key)
  end

  private

  def snakeize(str)
    str.gsub(/(?<l>\B[A-Z])/,'_\k<l>').downcase.to_sym
  end

  def nested_keys(obj=@data)
    keys = []
    if obj.values.map { |v| v.is_a?(Hash) }.flatten.include?(true)
      keys << obj.values.select { |v| v.is_a?(Hash) }.map {|v| nested_keys(v) }
    end
    [obj.keys,keys].flatten.sort
  end

  def nested_value(key,obj=@data)
    return [obj[key]] if obj.keys.include?(key)
    obj.values.select { |v| v.is_a?(Hash) }
    .map { |v| nested_value(key,v) }
    .flatten
  end

  def keys_to_snake_case(obj)
    return obj unless obj.is_a?(Hash)
    Hash[
      obj.map do |k,v|
        [snakeize(k), keys_to_snake_case(v)]
      end
    ]
  end

end
