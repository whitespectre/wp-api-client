require 'faraday'
require 'faraday_middleware'

module WpApiClient
  class Connection

    attr_accessor :headers

    def initialize(endpoint)
      @conn = Faraday.new(:url => endpoint) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        #faraday.response :logger                  # log requests to STDOUT
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    # translate requests into wp-api urls
    def get(url, params = {})
      @conn.get url, params.merge({_embed: true})
    end
  end
end
