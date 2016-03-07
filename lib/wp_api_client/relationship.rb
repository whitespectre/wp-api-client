require 'open-uri'

module WpApiClient
  class Relationship

    class << self
      attr_writer :mappings

      def mappings
        @mappings ||= default_mappings
      end

      def define(relation, type)
        mappings[relation] = type
      end

      def default_mappings
        {
          "https://api.w.org/term" => :term,
          "https://api.w.org/items" => :terms,
          "http://api.w.org/v2/post_type" => :post_type,
          "https://api.w.org/meta" => :meta,
          "https://api.w.org/featuredmedia" => :post
        }
      end

      def term(r)
        relations = {}
        r.resource["_links"][r.relation].each_with_index do |link, position|
          relations.merge! Hash[link["taxonomy"], r.load_relation(r.relation, position)]
        end
        relations
      end

      def terms(r)
        r.load_relation(r.relation, 0)
      end

      def post_type(r)
        relations = {}
        r.resource["_links"][r.relation].each_with_index do |link, position|
          # get the post type out of the linked URL.
          post_type = URI.parse(link["href"]).path.split('wp/v2/').pop.split('/').first
          relations.merge! Hash[post_type, r.load_relation(r.relation, position)]
        end
        relations
      end

      def post(r)
        r.load_relation(r.relation)
      end

      def meta(r)
        relations = {}
        meta = WpApiClient.get_client.get(r.resource["_links"][r.relation].first["href"])
        meta.map do |m|
          relations.merge! Hash[m.key, m.value]
        end
        relations
      end
    end

    attr_reader :resource
    attr_reader :relation

    def initialize(resource, relation)
      @resource = resource
      @relation = relation
    end

    def get_relations
      mapping = self.class.mappings[@relation]
      if !mapping
        raise WpApiClient::RelationNotDefined.new %{
=> The relation "#{@relation}" is not defined.

To add a new relation, define it at configuration. For example, to define this
relation as one that links to a post object, you would do the following.

WpApiClient.configure do |c|
  c.define_mapping(#{@relation}, :post)
end

The currently defined relations are:

#{self.class.mappings.keys.join("\n") }

Available mappings are :post, :term, and :meta.}
      end

      # Only try to fetch the relation if there are any links to it
      self.class.send(mapping, self) if resource["_links"][relation]
    end

    # try to load an embedded object; call out to the API if not
    def load_relation(relationship, position = nil)
      if objects = @resource.dig("_embedded", relationship)
        location = position ? objects[position] : objects
        WpApiClient::Collection.new(location)
      else
        unless position.nil?
          location = @resource["_links"].dig(relationship, position.to_i, "href")
        else
          if @resource["_links"][relationship].is_a? Array
            # If the resources are linked severally, crank through and
            # retrieve them one by one as an array
            return @resource["_links"][relationship].map { |link| WpApiClient.get_client.get(link["href"]) }
          else
            # Otherwise, get the single link to the lot
            location = @resource["_links"][relationship]["href"]
          end
        end
        WpApiClient.get_client.get(location) if location
      end
    end
  end
end
