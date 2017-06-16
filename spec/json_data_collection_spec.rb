require 'spec_helper'

describe JSN::DataCollection do

  let(:collection) { described_class.new({a: [{b: :c}, {d: :e}]}) }

  it 'should return JSONDataObjects for each item in an array' do
    expect(collection.first).to be_kind_of(JSN::DataObject)
  end

  it 'should return a: for id' do
    expect(collection.id).to eq(:a)
  end

  describe 'with a more complex data shape' do
    #note this is really a test of JSONDataObject and should get moved
    #it is just a sanity check for now.
    let(:data) { {a:[{b:{c:{d: :e}}},{f:{g:{h: :i}}}]}}
    let(:collection) { described_class.new(data) }

    it 'should return :e for first[:d]' do
      expect(collection.first[:d]).to eq(:e)
    end

    it 'should return {d: :e} for [0][:c]' do
      expect(collection[0][:c]).to eq({d: :e})
    end

    it 'should return :e for [0][:d]' do
      expect(collection[0][:d]).to eq(:e)
    end

    it 'should return :i for [1][:h]' do
      expect(collection[1][:h]).to eq(:i)
    end

    it 'should return an Enumerator for #map' do
      expect(collection.map).to be_kind_of(Enumerator)
    end

    it 'should return true for #any?' do
      expect(collection.any?).to be
    end
  end

  describe 'acccessing data from fixture' do
    include_context 'collection data'
    let(:collection) { described_class.new(file) }

    it 'should have an id of :properties' do
      expect(collection.id).to eq(:properties)
    end

    it 'should have 25 properties' do
      expect(collection.count).to eq(25)
    end

    it 'should have an id of 66840953 within the array of properties' do
      expect(collection.map { |p| p[:id] }).to include(66840953)
    end

    it 'should have a price of 1160 within the array of properties' do
      expect(collection.map { |p| p[:price][:amount] }).to include(1160)
    end

  end
end
