module WpApiClient
  module Entities
    class Image < Base
      alias :image :resource

      def self.represents?(json)
        json["media_type"] and json["media_type"] == 'image'
      end

      def sizes(size = :full)
        image.dig("media_details", "sizes", size.to_s, "source_url")
      end
    end
  end
end
