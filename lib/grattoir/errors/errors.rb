module Grattoir
  module Errors
    MismatchedKeys = Class.new(ArgumentError)
    MismatchedValues = Class.new(ArgumentError)
    KeyNotFound = Class.new(ArgumentError)
  end
end
