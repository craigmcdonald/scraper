require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'json'
require 'dotenv'
require 'celluloid/current'

class Parser
  include Capybara::DSL
  include Celluloid

  attr_accessor :page_loaded

  def initialize(url,opts={})
    @url = url
    scraper = opts[:scraper] || Capybara::Session
    driver = opts[:driver] || :poltergeist
    @session = scraper.new(driver)
    @session.driver.headers = {"User-Agent": opts[:ua_string] || ENV['UA_STRING']}
    after_initialize
  end

  def after_initialize;end

  def load_page
    @session.visit @url
    @page_loaded = true
  end

  private

  def snakeize(str)
    str.gsub(/(?<l>\B[A-Z])/,'_\k<l>').downcase.to_sym
  end

  def keys_to_snake_case(obj)
    return obj unless obj.is_a?(Hash)
    Hash[
      obj.map do |k,v|
        [snakeize(k), keys_to_snake_case(v)]
      end
    ]
  end

end
