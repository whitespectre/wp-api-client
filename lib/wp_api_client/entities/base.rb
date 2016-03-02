require 'open-uri'

module WpApiClient
  module Entities
    class Base
      attr_reader :resource

      def self.build(resource, api)
        raise Exception if resource.nil?
        type = WpApiClient::Entities::Types.find { |type| type.represents?(resource) }
        type.new(resource, api)
      end

      def initialize(resource, api)
        unless resource.is_a? Hash
          raise ArgumentError.new('Tried to initialize a WP-API resource with something other than a Hash')
        end
        @resource = resource
        @api = api
      end

      def links
        resource["_links"]
      end

      def relations(relationship, relation_to_return = nil)
        relations = {}
        case relationship
        when "https://api.w.org/term"
          links[relationship].each_with_index do |link, position|
            relations.merge! Hash[link["taxonomy"], load_relation(relationship, position)]
          end
        when "http://api.w.org/v2/post_type"
          links[relationship].each_with_index do |link, position|
            # get the post type out of the linked URL.
            post_type = URI.parse(link["href"]).path.split('wp/v2/').pop
            relations.merge! Hash[post_type, load_relation(relationship, position)]
          end
        when "https://api.w.org/meta"
          meta = @api.get(links[relationship].first["href"])
          meta.map do |m|
            relations.merge! Hash[m.key, m.value]
          end
        end
        if relation_to_return
          relations[relation_to_return]
        else
          relations
        end
      end

    private

      # try to load an embedded object; call out to the API if not
      def load_relation(relationship, position)
        if objects = resource.dig("_embedded", relationship)
          WpApiClient::Collection.new(objects[position])
        else
          @api.get(links[relationship][position]["href"])
        end
      end
    end
  end
end
