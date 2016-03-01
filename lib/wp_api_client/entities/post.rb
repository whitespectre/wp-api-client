module WpApiClient
  module Entities
    class Post < BaseEntity
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

      def terms
        if embedded?
          terms = []
          embedded["https://api.w.org/term"].map do |taxonomy|
            taxonomy.each do |term|
              terms << WpApiClient::Entities::Term.new(term, @api)
            end
          end
          terms
        end
      end
    end
  end
end
