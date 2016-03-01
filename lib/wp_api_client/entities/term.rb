module WpApiClient
  module Entities
    class Term < Base
      alias :term :resource

      def self.represents?(json)
        json.dig("_links", "about") and json["_links"]["about"].first["href"] =~ /wp\/v2\/taxonomies/
      end

      def taxonomy
        @api.get(links["about"].first["href"])
      end

      def posts(post_type = nil)
        relations("http://api.w.org/v2/post_type", post_type)
      end

      def name
        term["name"]
      end

      def slug
        term["slug"]
      end

      def id
        term["id"]
      end

    end
  end
end
