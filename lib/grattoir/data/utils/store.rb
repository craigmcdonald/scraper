module Grattoir
  module Data
    module Utils
      module Store
        class Store < Hash

          def [](key)
            key = key.to_sym if key
            super key
          end

          def []=(key,value)
            key = key.to_sym if key
            super key, value
          end
        end
      end
    end
  end
end
