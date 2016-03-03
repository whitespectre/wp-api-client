require 'faraday'
require 'faraday_middleware'

module WpApiClient
  class Connection

    attr_accessor :headers

    def initialize(configuration)
      @configuration = configuration
      @conn = Faraday.new(url: configuration.endpoint) do |faraday|
        if configuration.oauth_credentials
          faraday.use FaradayMiddleware::OAuth, configuration.oauth_credentials
        end
        if configuration.debug
          faraday.response :logger
        end
        faraday.use Faraday::Response::RaiseError
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    # translate requests into wp-api urls
    def get(url, params = {})
      @conn.get url, params.merge(@configuration.request_params)
    end
  end
end
