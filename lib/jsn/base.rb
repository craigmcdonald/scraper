module JSN
  class Base
    def deep_copy
      Marshal.load(Marshal.dump(self))
    end
  end

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
