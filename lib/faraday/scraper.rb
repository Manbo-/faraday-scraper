require "pry"
require "nokogiri"

require "faraday"
require "faraday/scraper/middleware"
require "faraday/scraper/register"
require "faraday/scraper/version"

module Faraday
  class Response
    attr_accessor :data
  end
  
  class Scraper
    module Rules
    end
  end
end

