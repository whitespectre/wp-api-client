module WpApiClient
  module Entities
    class Taxonomy < BaseEntity
      alias :taxonomy :resource

      def self.represents?(json)
        !json.dig("hierarchical").nil?
      end

      def name
        taxonomy["name"]
      end

      def terms
        @api.get(links["https://api.w.org/items"].first["href"])
      end
    end
  end
end
