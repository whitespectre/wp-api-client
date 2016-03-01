module WpApiClient
  module Entities
    class BaseEntity
      attr_reader :resource

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

      def embedded
        resource["_embedded"]
      end

      alias :embedded? :embedded
    end
  end
end
