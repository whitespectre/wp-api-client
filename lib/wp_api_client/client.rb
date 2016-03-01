module WpApiClient
  class Client

    Types = [
      WpApiClient::Entities::Image,
      WpApiClient::Entities::Post,
      WpApiClient::Entities::Term,
      WpApiClient::Entities::Taxonomy
    ]

    def initialize(connection)
      @connection = connection
    end

    def get(url, params = {})
      response = @connection.get(api_path_from(url), params)
      @headers = response.headers

      native_representation_of response.body
    end

  private

    def api_path_from(url)
      url.split('wp/v2/').last
    end

    # Take the API response and figure out what it is
    def native_representation_of(response_body)
      if response_body.is_a? Array
        collection = true
        object = response_body.first
      else
        collection = false
        object = response_body
      end

      type = Types.find { |type| type.represents?(object) }

      if collection
        resources = response_body.map! { |object| type.new(object, self) }
        WpApiClient::Collection.new(resources, @headers)
      else
        type.new(response_body, self)
      end
    end
  end
end
