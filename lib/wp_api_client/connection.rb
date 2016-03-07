require 'faraday'
require 'faraday_middleware'
require 'faraday-http-cache'
require 'typhoeus/adapters/faraday'

module WpApiClient
  class Connection

    attr_accessor :headers

    def initialize(configuration)
      @configuration = configuration
      @conn = Faraday.new(url: configuration.endpoint) do |faraday|

        if configuration.oauth_credentials
          faraday.use FaradayMiddleware::OAuth, configuration.oauth_credentials
        end

        if configuration.basic_auth
          faraday.basic_auth(configuration.basic_auth[:username], configuration.basic_auth[:password])
        end

        if configuration.debug
          faraday.response :logger
        end

        if configuration.cache
          faraday.use :http_cache, store: configuration.cache
        end

        faraday.use Faraday::Response::RaiseError
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter  :typhoeus
      end
    end

    # translate requests into wp-api urls
    def get(url, params = {})
      @conn.get url, parse_params(params)
    end

    def parse_params(params)
      params = @configuration.request_params.merge(params)
      # if _embed is present at all it will have the effect of embedding —
      # even if it's set to "false"
      if params[:_embed] == false
        params.delete(:_embed)
      end
      params
    end
  end
end
