module WpApiClient
  module Entities
    class Meta < Base
      alias :meta :resource

      def self.represents?(json)
        json["key"] and json["value"]
      end

      def key
        meta["key"]
      end

      def value
        meta["value"]
      end
    end
  end
end
