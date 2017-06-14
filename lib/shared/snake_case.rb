module Shared
  module SnakeCase

    def snakeize(str)
      str.gsub(/(?<l>\B[A-Z])/,'_\k<l>').downcase.to_sym
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
end
