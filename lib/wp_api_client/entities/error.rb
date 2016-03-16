module WpApiClient
  module Entities
    class Error

      def self.represents?(json)
        json.key?("code") and json.key?("message")
      end

      def initialize(json)
        raise WpApiClient::ErrorResponse.new(json)
      end
    end
  end
end
