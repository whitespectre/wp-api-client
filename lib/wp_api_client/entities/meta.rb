module WpApiClient
  module Entities
    class Meta < Base
      alias :meta :resource

      def self.represents?(json)
        json["key"] and json["value"]
      end

    end
  end
end
