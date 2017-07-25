module Grattoir
  module Scrapers
    class Base
      include Capybara::DSL
      include Celluloid

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

      def fetch_json_value(attribute)
        json_obj[attribute]
      end

      def in_json_obj?(key)
        json_obj.has_key? key
      end

      def json_obj
        @json_obj ||= Data::Model.new(Data::Parser.parse(script_data))
      end

      def load_page
        @session.visit @url
        @page_loaded = true
      end

      def method_missing(meth, *args, &block)
        super
      end

      def respond_to?(meth,include_all=false)
        super
      end

      def set_up_methods(array=[])
        array.each do |key|
          define_singleton_method(key) { method_missing(key) }
        end
      end
    end
  end
end
