describe Parser do

  let(:scraper) { double('Copybara') }
  let(:scraper_instance) { double('Copybara Instance') }
  let(:driver) { double('Driver')}
  let(:parser) { described_class.new('http://example.org',{ scraper: scraper })}

  before(:each) do
    allow(scraper).to receive(:new).and_return(scraper_instance)
    allow(scraper_instance).to receive(:visit)
    allow(scraper_instance).to receive(:driver).and_return(driver)
    allow(driver).to receive(:headers=)
  end

  specify 'the page should be loaded after #load_page is called' do
    parser.load_page
    expect(parser.page_loaded).to be
  end
end
