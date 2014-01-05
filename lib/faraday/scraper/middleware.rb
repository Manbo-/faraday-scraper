class Faraday::Scraper
  class Middleware < Faraday::Middleware
    Faraday.register_middleware scraper: Faraday::Scraper::Middleware

    def initialize(app, namespace)
      super(app)
      @rules = init_rules(namespace)
    end
    
    def call(env)
      data = {}
      match_rules(env).each do |rule|
        rule.before_request[env] if rule.respond_to?(:before_request)
      end

      @app.call(env).on_complete do
        match_rules(env).each do |rule|
          rule.before_scraping[env[:body]] if rule.respond_to?(:before_scraping)
        end

        match_rules(env).each do |rule|
          key = key(rule)
          doc = Nokogiri::HTML(env[:body])
          data[key] ||= []
          data[key] += doc.xpath(rule.xpath)
          if rule.respond_to?(:xpath_block)
            data[key].map! do |element|
              rule.xpath_block[element, env]
            end
          end
        end
        env[:response].data = data
      end
    end

    private

    def init_rules(namespace)
      namespace.constants.map do |rule|
        namespace.const_get(rule).new
      end
    end

    def match_rules(env)
      @rules.select do |rule|
        rule.site =~ env[:url].to_s
      end
    end

    def key(rule)
      rule.class.name.split("::").last
    end
  end
end
