require_relative 'base_scraper'

module RightMove
  class CollectionScraper < BaseScraper

    def after_initialize
      load_page
      set_up_methods(json_obj.keys)
    end

    def method_missing(meth, *args, &block)
      return fetch_json_value(meth) if in_json_obj? meth
      super
    end

    def respond_to?(meth,include_all=false)
      in_json_obj?(meth) ||
      super
    end

    private

    def script_data
      @script_data ||= @session.all('script', visible: false).select do |scr|
        scr.text(:all).match(/"properties":/)
      end
        .first
        .text(:all)
        .match(/(.*=\s)(.*)/)[2]
    end
  end
end
