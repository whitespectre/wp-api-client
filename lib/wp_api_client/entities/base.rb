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

      def relations(relation, relation_to_return = nil)
        relationship = Relationship.new(@api, @resource, relation)
        relations = relationship.get_relations
        if relation_to_return
          relations[relation_to_return]
        else
          relations
        end
      end
    end
  end
end
