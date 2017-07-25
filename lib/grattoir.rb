require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'json'
require 'dotenv'
require 'celluloid/current'

module Grattoir;end

require_relative 'grattoir/errors/errors'
require_relative 'grattoir/scrapers/base'
require_relative 'grattoir/data'
