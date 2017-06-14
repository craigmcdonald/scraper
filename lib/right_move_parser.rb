class RightMoveParser < Parser
  def initialize(url,opts={})
    @table_data = {}
    super
  end

  def after_initialize
    load_page
    parse_table
    set_up_methods
  end

  def method_missing(meth, *args, &block)
    return fetch_table_row(meth) if in_table? meth
    return fetch_property(meth) if in_properties? meth
    super
  end

  def respond_to?(meth,include_all=false)
    in_properties?(meth) ||
    in_table?(meth) ||
    super
  end

  def fetch_table_row(key)
    @table_data[key]
  end

  def in_table?(key)
    @table_data.keys.include?(key)
  end

  def fetch_property(attribute)
    property_info[attribute] || property_location[attribute]
  end

  def in_properties?(key)
    in_property_info?(key) || in_property_location?(key)
  end

  def property_location
    properties[:location]
  end

  def in_property_location?(key)
    property_location.keys.include?(key)
  end

  def property_info
    properties[:property_info]
  end

  def in_property_info?(key)
    property_info.keys.include?(key)
  end

  def properties
    @properties ||= keys_to_snake_case(JSON.parse(script_data)['property'])
  end

  private

  def set_up_methods
    [@table_data.keys, property_info.keys, property_location.keys].flatten
    .each do |key|
      define_singleton_method(key) { method_missing(key) }
    end
  end

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
    @table_parsed = true
  end

  def parse_row(text)
    return nil unless @session.all('td').find {|td| td.text == text }
    @session.all('td')[@session.all('td').find_index {|td| td.text == text }+1].text
  end
end
