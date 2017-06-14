require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'json'
require 'dotenv'
require 'celluloid/current'

class Scraper
  include Capybara::DSL
  include Celluloid
  include Shared::SnakeCase

  attr_accessor :page_loaded

  def initialize(url,opts={})
    @url = url
    browser = opts[:browser] || Capybara::Session
    driver = opts[:driver] || :poltergeist
    @session = browser.new(driver)
    @session.driver.headers = {"User-Agent": opts[:ua_string] || ENV['UA_STRING']}
    after_initialize
  end

  def after_initialize;end

  def load_page
    @session.visit @url
    @page_loaded = true
  end
end
