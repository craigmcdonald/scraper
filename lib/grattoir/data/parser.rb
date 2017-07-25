require 'json'

module Grattoir
  module Data
    class Parser
      extend Utils::SnakeCase

      def self.parse(str)
        keys_to_snake_case(JSON.parse(str))
      end
    end
  end
end
