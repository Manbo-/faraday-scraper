require "spec_helper"

module Rules; end

describe Faraday::Scraper do
  let(:sample) do
    "/sample"
  end

  let(:missing) do
    "/missing"
  end

  let(:connection) do
    Faraday.new do |builder|
      builder.use :scraper, Rules
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/sample'){ [200, {}, open("spec/sample.html").read] }
        stub.get('/missing'){ [200, {}, open("spec/sample.html").read] }
      end
    end
  end

  before :all do
    Rules::Sample = Class.new(Faraday::Scraper::Register) do
      site /sample/
      
      before_scraping do |body|
        body.gsub!("amg", "img")
      end

      scrape "//img" do |img, env|
        URI.join(env[:url], img[:src])
      end
    end
  end

  context "when using middleware" do
    let(:response) do
      connection.get(sample)
    end

    it do
      expect(response.body).to_not be_nil
    end

    describe "#data" do
      it do
        expect(response.data).to_not be_empty
      end

      it do
        expect(response.data["Sample"]).to have(3).items
      end

      it do
        expect(response.data["Sample"]).to be_all{ |img| img.is_a?(URI) }
      end
    end
  end

  context "when missing middleware" do
    let(:response) do
      connection.get(missing)
    end

    it do
      expect(response.data).to be_empty
    end
  end
end
