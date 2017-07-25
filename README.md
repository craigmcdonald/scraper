# Concurrent Scraper

A concurrent scraper experiment which uses Capybara and Celluloid (and Rightmove as a target site).

## To-do

- ~~Figure out why puffing-billy is not caching everything (presumably because some of the urls are changing as well as just the params)~~
- ~~Stop PhantomJS from outputting contents of console log~~
- Build a spidering service to accept a page of search results and then scrape each page
- Create a data structure for the scraped results and persist
- Add error handling and retrying
- Better logging, including warnings of failed scrapes  / spiders
- Scheduling recurring spidering / scraping
- Web-based admin panel
- Package and deployment
