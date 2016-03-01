module WpApiClient
  module Entities
    class Term < BaseEntity
      alias :term :resource

      def self.represents?(json)
        json.dig("_links", "about") and json["_links"]["about"].first["href"] =~ /wp\/v2\/taxonomies/
      end

      def taxonomy
        @api.get(links["about"].first["href"])
      end

      def posts(post_type = "post")
        post_type_links = links["http://api.w.org/v2/post_type"]
        link = post_type_links.find { |link| link["href"] =~ /wp\/v2\/#{post_type}/ }
        @api.get(link["href"]) if link
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
