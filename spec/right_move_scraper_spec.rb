require 'spec_helper'

describe RightMoveScraper do

  let(:scraper)  do
     described_class.new(
      'http://www.rightmove.co.uk/property-to-rent/property-60384643.html',
      {driver: :poltergeist_billy})
  end

  around(:each) do |example|
    proxy.cache.with_scope "3-bed house" do
      example.run
    end
  end

  it 'should return a price of 1160' do
    expect(scraper.price).to eq(1160)
  end

  it 'should return 3 beds' do
    expect(scraper.beds).to eq(3)
  end

  it 'should return Furnished' do
    expect(scraper.furnishing).to eq('Furnished')
  end

  it 'should return a postcode of G13 2TZ' do
    expect(scraper.postcode).to eq('G13 2TZ')
  end

  it 'should respond_to available_from' do
    expect {scraper.respond_to?('available_from') }.to_not raise_error
  end

  it 'should return a NoMethodError for a missing method' do
    expect {scraper.not_a_method }.to raise_error(NoMethodError)
  end
end
