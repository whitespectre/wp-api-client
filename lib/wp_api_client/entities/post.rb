module WpApiClient
  module Entities
    class Post < Base
      alias :post :resource

      def self.represents?(json)
        json.dig("_links", "about") and json["_links"]["about"].first["href"] =~ /wp\/v2\/types/
      end

      def title
        post["title"]["rendered"]
      end

      def date
        Time.new(post["date_gmt"])
      end

      def content
        post["content"]["rendered"]
      end

      def id
        post["id"]
      end

      def terms(taxonomy = nil)
        relations("https://api.w.org/term", taxonomy)
      end
    end
  end
end
