require 'json'

module JSN
  class Parser
    extend Shared::SnakeCase
    
    def self.parse(str)
      keys_to_snake_case(JSON.parse(str))
    end
  end
end
