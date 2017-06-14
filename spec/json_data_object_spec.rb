require 'spec_helper'

describe JsonDataObject do

  describe 'initialization' do

    let(:json_obj_invalid) {described_class.new('string')}
    let(:json_obj_valid) { described_class.new("{\"a\": \"string\"}")}

    it 'should raise an error if passed an invalid JSON string' do
      expect { json_obj_invalid }.to raise_error(JSON::ParserError)
    end

    it 'should not raise an error if passed a valid JSON string' do
      expect { json_obj_valid }.to_not raise_error
    end
  end

  describe 'accessing @data' do

    let(:json_obj) { described_class.new("{\"a\": \"string\"}") }

    it 'should return a value for :a' do
      expect(json_obj[:a]).to eq('string')
    end

    it 'should return true for a valid key' do
      expect(json_obj.has_key? :a).to be
    end

    it 'should return false for an invalid key' do
      expect(json_obj.has_key? :b).to_not be
    end
  end

  describe 'accesing nested data' do
    let(:json_obj) { described_class.new("{\"a\":{\"b\":\"c\"},\"d\":{\"e\":\"f\"}}") }

    it 'should return true for :b' do
      expect(json_obj.has_key? :b).to be
    end

    it 'should return true for :d' do
      expect(json_obj.has_key? :d).to be
    end

    it 'should return true for :e' do
      expect(json_obj.has_key? :d).to be
    end

    it 'should return [:a,:b,:d,:e] for #keys' do
      expect(json_obj.keys).to eq([:a,:b,:d,:e])
    end

    it 'should return "c" for a key of :b' do
      expect(json_obj[:b]).to eq('c')
    end

    it 'should return nil for a key of :p' do
      expect(json_obj[:p]).to_not be
    end
  end

  describe 'acccessing data from fixture' do
    let(:file) { File.open("#{__dir__}/fixtures/sample.json") }
    let(:json_obj) { described_class.new(file.read) }

    it 'should return true for postcode' do
      expect(json_obj.has_key? :postcode).to be
    end

    it 'should return true for beds' do
      expect(json_obj.has_key? :beds).to be
    end

    it 'should return true for price' do
      expect(json_obj.has_key? :price).to be
    end
  end

  describe 'accessing empty data' do
    let(:json_obj) { described_class.new("{}") }

    it 'should return false for postcode' do
      expect(json_obj.has_key? :postcode).to_not be
    end
  end
end
