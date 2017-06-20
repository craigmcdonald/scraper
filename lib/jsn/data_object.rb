require_relative '../error_classes/deep_merge_errors'
require_relative 'base'

module JSN
  class DataObject < JSN::Base

    def initialize(data)
      @data = store_data(data)
    end

    def store_data(data)
      @data = Store[
        data.map do |k,v|
          [k, v .is_a?(Array) ? DataCollection.new({k => v}) : v]
        end
      ]
    end

    def keys
      nested_keys
    end

    def has_key?(key)
      nested_keys.include?(key.to_sym)
    end

    def [](key)
      value_at_key(key.to_sym) if has_key?(key.to_sym)
    end

    def deep_merge_at(key,obj)
      deep_copy.send(:merge_at_key,key,obj.deep_copy)
    end

    # private

    def upsert(key, col)
      method_array(key).inject(@data) do |obj,method|
        return obj.send(*(method.map(&:to_sym) << col)) if method[0].index("=")
        obj.send(*method.map(&:to_sym))
      end
    end

    def upsert_with_collection(key,*args)
      upsert(key, DataCollection.new({key => args}))
    end

    def merge_at_key(key,obj)
      raise mismatched_keys unless matching_keys(key,obj)
      if both_collections(key,obj)
        upsert(key,self[key].deep_merge_at(key, obj[key]))
      else
        upsert_with_collection(key,self[key],obj[key])
      end
      self
    end

    def mismatched_keys
      DeepMergeError::MismatchedKeys.new
    end

    def mismatched_values
      DeepMergeError::MismatchedValues.new
    end

    def both_collections(key,obj)
      raise mismatched_values unless self[key].class == obj[key].class
      self[key].is_a?(DataCollection) && obj[key].is_a?(DataCollection)
    end

    def matching_keys(key,obj)
      self.send(:key_level,key) == obj.send(:key_level,key)
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

    def value_at_key(key)
      value = nested_value(key)
      value.length > 1 ? value : value[0]
    end

    def nested_value(key,obj=@data)
      return [obj[key]] if obj.keys.include?(key)
      obj.values.select { |v| v.is_a?(Hash) }
      .map { |v| nested_value(key,v) }
      .flatten
    end

    def method_array(key)
      array = key_with_parents(key)
      array.map.with_index  do |v,i|
        i+1 == array.length ? ["[]=","#{v}"] : ["[]","#{v}"]
      end
    end

    def key_with_parents(key)
      array = []
      traverse_keys do |child,_,parent|
        array << child && next if array.empty? && child
        if array.index(parent)
          array.slice!((array.index(parent)+1)..-1)
        else
          array = []
        end
        array << child if child
        break if child == key
      end
      array
    end

  end
end
