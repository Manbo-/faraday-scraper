class Faraday::Scraper
  class Register
    class Undefined < Exception; end

    def site
      raise Faraday::Scraper::Register::Undefined
    end

    def xpath
      raise Faraday::Scraper::Register::Undefined
    end

    class << self
      def site(site)
        define_method(:site) do
          site
        end
      end

      def before_request(&block)
        define_method(:before_request) do
          block
        end
      end

      def before_scraping(&block)
        define_method(:before_scraping) do
          block
        end
      end

      def scrape(xpath, &block)
        define_method(:xpath) do
          xpath
        end

        define_method(:xpath_block) do
          block
        end
      end
    end
  end
end
