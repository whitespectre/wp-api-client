module WpApiClient
  module Entities
    class Taxonomy < Base
      alias :taxonomy :resource

      def self.represents?(json)
        !json.dig("hierarchical").nil?
      end

      def terms
        relations("https://api.w.org/items")
      end
    end
  end
end
