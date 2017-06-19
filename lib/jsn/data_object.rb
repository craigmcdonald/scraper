module JSN
  class DataObject

    DeepMergeError = Module.new
    DeepMergeError::MismatchedKeys = Class.new(ArgumentError)

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

    def deep_merge_on(key,obj)
      deep_copy.send(:merge_by_key,key,obj.deep_copy)
    end

    def deep_copy
      Marshal.load(Marshal.dump(self))
    end

    private

    def merge_by_key(key,obj)
      unless self.send(:key_level,key) == obj.send(:key_level,key)
        raise DeepMergeError::MismatchedKeys.new
      end
      true
    end

    def key_level(key)
      hash = {}
      keys_at_depth do |k,i|
        hash[k] = i if k
      end
      hash[key]
    end

    def keys_at_depth(obj=@data,k=nil,i=0,&block)
      yield k,i
      return if k && !(obj[k].is_a?(Hash) || obj[k].is_a?(Array)) && k
      return obj[k].map { |v|  keys_at_depth(v,nil,i+1, &block) } if obj[k].is_a?(Array) && k
      return obj[k].keys.map { |q| keys_at_depth(obj[k],q,i+1,&block) } if obj[k].is_a?(Hash) && k
      obj.keys.map { |k| keys_at_depth(obj,k,i,&block) } && nil
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

    def upsert_at_key(key,data)
      # navigate to the key
      # if not an array
        # create an array, copy the data
      # convert to array
    end
  end
end
