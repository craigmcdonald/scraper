require_relative '../scraper'

module RightMove
  class BaseScraper < Scraper

    def fetch_json_value(attribute)
      json_obj[attribute]
    end

    def in_json_obj?(key)
      json_obj.has_key? key
    end

    def json_obj
      @json_obj ||= JSN::DataObject.new(JSN::Parser.parse(script_data))
    end

  end
end
