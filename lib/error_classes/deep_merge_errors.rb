module DeepMergeError
  MismatchedKeys = Class.new(ArgumentError)
  MismatchedValues = Class.new(ArgumentError)
  KeyNotFound = Class.new(ArgumentError)
end
