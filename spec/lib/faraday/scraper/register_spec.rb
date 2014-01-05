require "spec_helper"

describe Faraday::Scraper::Register do
  before do
    @register = Class.new(Faraday::Scraper::Register) do
      site /site_regex/

      before_request do |env|
        print env
      end

      before_scraping do |body|
        print body
      end

      scrape "//img" do |element|
        element[:src]
      end
    end
  end

  describe "." do
    it do
      %i(site before_request before_scraping scrape).each do |method_name|
        expect(@register).to be_respond_to method_name
      end
    end
  end

  describe "#" do
    it do
      expect(@register.new.site).to eq /site_regex/
    end

    it do
      expect(@register.new.before_request).to be_a_kind_of Proc
    end

    it do
      expect(@register.new.before_scraping).to be_a_kind_of Proc
    end

    it do
      expect(@register.new.xpath).to eq "//img"
    end

    it do
      expect(@register.new.xpath_block).to be_a_kind_of Proc
    end
  end
end
