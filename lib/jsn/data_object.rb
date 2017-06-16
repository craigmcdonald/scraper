module JSN
  class DataObject

    def initialize(data)
      @data = store_data(data)
    end

    def store_data(data)
      @data = Hash[
        data.map do |k,v|
          [k, v .is_a?(Array) ? DataCollection.new({k => v}) : v]
        end
      ]
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
  end
end
