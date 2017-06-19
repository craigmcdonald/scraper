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
      value_from_key(key) if has_key?(key)
    end

    def deep_merge_on(key,obj)
      deep_copy.send(:merge_by_key,key,obj.deep_copy)
    end

    def deep_copy
      Marshal.load(Marshal.dump(self))
    end

    private

    def value_from_key(key)
      value = nested_value(key)
      value.length > 1 ? value : value[0]
    end

    def merge_by_key(key,obj)
      unless self.send(:key_level,key) == obj.send(:key_level,key)
        raise DeepMergeError::MismatchedKeys.new
      end
      if self[key].is_a?(DataCollection) && obj[key].is_a?(DataCollection)
        self[key].deep_merge_on(k,obj[key])
      else
        upsert_with_collection(key,self[key],obj[key])
      end
      self
    end

    def key_level(key)
      hash = {}
      traverse_keys { |k,i,_| hash[k] = i if k }
      hash[key] || -> { raise DeepMergeError::KeyNotFound.new }.call
    end

    def traverse_keys(obj=@data,k=nil,old_k=nil,i=0,&block)
      yield k,i,old_k
      return if k && !(obj[k].is_a?(Hash) || obj[k].is_a?(Array)) && k
      return obj[k].map { |v|  traverse_keys(v,nil,k,i+1, &block) } if obj[k].is_a?(Array) && k
      return obj[k].keys.map { |q| traverse_keys(obj[k],q,k,i+1,&block) } if obj[k].is_a?(Hash) && k
      obj.keys.map { |q| traverse_keys(obj,q,k,i,&block) } && nil
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

    def upsert_with_collection(key,*args)
      traverse_keys do |k,_,old_k|
        if key == k
          @data[old_k][k] = DataCollection.new({k => args})
          break
        end
      end
    end
  end
end
