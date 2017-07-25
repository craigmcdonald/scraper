describe Grattoir::Scrapers::Base do

  let(:browser) { double('Copybara') }
  let(:browser_instance) { double('Copybara Instance') }
  let(:driver) { double('Driver')}
  let(:scraper) { described_class.new('http://example.org',{ browser: browser })}

  before(:each) do
    allow(browser).to receive(:new).and_return(browser_instance)
    allow(browser_instance).to receive(:visit)
    allow(browser_instance).to receive(:driver).and_return(driver)
    allow(driver).to receive(:headers=)
  end

  specify 'the page should be loaded after #load_page is called' do
    scraper.load_page
    expect(scraper.page_loaded).to be
  end
end
