require 'forwardable'

module JSN
  class DataCollection
    extend Forwardable

    attr_reader :id
    def_delegators :@data, *Array.instance_methods(false)

    def initialize(data)
      @id = data.keys.first
      store_data(data)
    end

    def store_data(data)
      @data = data[@id].map { |v| DataObject.new(v) } if data[@id].is_a?(Array)
    end
  end
end
