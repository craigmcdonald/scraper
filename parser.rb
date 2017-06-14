#!/usr/bin/env ruby

# quick script to test concurrent fetching of data via the terminal.

require 'pry'
Dir["#{__dir__}/lib/*.rb"].each {|f| require f }
Capybara.threadsafe = true
Capybara.default_driver = :poltergeist
Dotenv.load # For development only.

puts 'What are the ids of the properties?'
prop_id = gets
parsers = []
prop_id.strip.split(',').each do |p_id|
  parsers << RightMoveParser.new("http://www.rightmove.co.uk/property-to-rent/property-#{p_id}.html").future(:price)
end

puts parsers.map(&:value)
