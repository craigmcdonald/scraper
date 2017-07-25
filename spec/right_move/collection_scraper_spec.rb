require 'spec_helper'

describe RightMove::CollectionScraper do

  let(:spider) { described_class.new(
   'http://www.rightmove.co.uk/property-to-rent/find.html?locationIdentifier=OUTCODE%5E926&minBedrooms=2&radius=0.25&sortType=2',
   {driver: :poltergeist_billy}) }

   it 'should return a properties collection' do
     expect(spider.properties).to be_kind_of(Grattoir::Data::Collection)
   end

   it 'should return a property with an id of 60096055' do
     expect(spider.properties.map { |p| p[:id] }).to include(60096055)
   end

   it 'should return a result count of 57' do
     expect(spider.result_count).to eq("57")
   end

end
