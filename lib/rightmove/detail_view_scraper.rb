require_relative 'base_scraper'

module RightMove
  class DetailViewScraper < BaseScraper
    def initialize(url,opts={})
      @table_data = {}
      super
    end

    def after_initialize
      load_page
      parse_table
      set_up_methods([@table_data.keys, json_obj.keys].flatten)
    end

    def method_missing(meth, *args, &block)
      return fetch_table_row(meth) if in_table? meth
      return fetch_json_value(meth) if in_json_obj? meth
      super
    end

    def respond_to?(meth,include_all=false)
      in_json_obj?(meth) ||
      in_table?(meth) ||
      super
    end

    def fetch_table_row(key)
      @table_data[key]
    end

    def in_table?(key)
      @table_data.keys.include?(key)
    end

    private

    def script_data
      @script_data ||= @session.all('script', visible: false).select do |scr|
        scr.text(:all).match(/propertyType/)
      end
        .first
        .text(:all)
        .match(/(}\()(.*)(\)\))/)[2]
    end

    def parse_table
      @table_data[:deposit] = parse_row('Deposit:')
      @table_data[:furnishing] = parse_row('Furnishing:')
      @table_data[:available_from] = parse_row('Date available:')
    end

    def parse_row(text)
      return nil unless @session.all('td').find {|td| td.text == text }
      @session.all('td')[@session.all('td').find_index {|td| td.text == text }+1].text
    end
  end
end
