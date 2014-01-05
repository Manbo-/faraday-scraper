module Namespace
  class Template < Faraday::Scraper::Register
    site %r(\Ahttp://)
    
    # before_request do |env|
    # end

    # before_scraping do |body|
    # end
    
    scrape "" do |elem|
    end
  end
end
