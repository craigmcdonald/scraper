module Grattoir
  module Data
    module Utils
      module SnakeCase

        def snakeize(str)
          str.gsub(/(?<l>\B[A-Z])/,'_\k<l>').downcase.to_sym
        end

        def keys_to_snake_case(obj)
          return obj unless obj.is_a?(Hash) || obj.is_a?(Array)
          return obj.map {|v| keys_to_snake_case(v) } if obj.is_a?(Array)
          Hash[
            obj.map do |k,v|
              [snakeize(k), keys_to_snake_case(v)]
            end
          ]
        end
      end
    end
  end
end
