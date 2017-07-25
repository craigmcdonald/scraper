module Grattoir
  module Data
    module Utils
      module Copy

        def deep_copy
          Marshal.load(Marshal.dump(self))
        end
      end
    end
  end
end
