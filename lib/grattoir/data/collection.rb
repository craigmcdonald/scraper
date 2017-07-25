require 'forwardable'

module Grattoir
  module Data
    class Collection
      include Utils::Copy
      include Utils::Store

      attr_reader :id
      extend Forwardable
      def_delegators :@data, *Array.instance_methods(false)

      def initialize(data)
        @id = data.keys.first
        store_data(data)
      end

      def deep_merge_at(key, obj)
        new_self = self.deep_copy
        new_self += obj
        self.class.new({key => new_self})
      end

      def store_data(data)
        @data = data[@id].map do |v|
          v.is_a?(Data::Model) ? v : Data::Model.new(v)
        end if data[@id].is_a?(Array)
      end
    end
  end
end
