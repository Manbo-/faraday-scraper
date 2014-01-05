# Faraday::Scraper

## Installation

    $ git clone https://github.com/Manbo-/faraday-scraper
    $ cd faraday-scraper
    $ rake install

## Usage

    require "faraday/scraper"
    
    module Pages
      class Links < Faraday::Scraper::Register
        site /.*/
    
        scrape "//a" do |a, env|
          URI.join(env[:url], a[:href]).to_s
        end
      end
    
      class Imgs < Faraday::Scraper::Register
        site /.*/
    
        scrape "//img" do |img, env|
          URI.join(env[:url], img[:src]).to_s
        end
      end
    end
    
    connection = Faraday.new do |builder|
      builder.use      :scraper, Pages
      builder.adapter  :net_http
    end
    
    response = connection.get(...)
    puts "links"
    puts response.data["Links"] # => http://...
    puts "images"
    puts response.data["Imgs"]  # => http://...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
