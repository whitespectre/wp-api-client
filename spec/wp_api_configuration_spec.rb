require 'webmock/rspec'

RSpec.describe WpApiClient::Configuration do
  describe "#configure" do

    it "can set the endpoint URL for the API connection" do
      VCR.turned_off do

        imaginary_api_location = "http://example.com/wp-json/wp/v2"

        # get an example API response and mock it
        resp = YAML.load(File.read 'spec/cassettes/custom_post_type_collection.yml')['http_interactions'][0]['response']['body']['string']
        ::WebMock.stub_request(:get,
          imaginary_api_location + "/custom_post_type?_embed=true"
        ).to_return(
          body: resp,
          headers: {'Content-Type' => 'application/json'}
        )

        # Configure the API client to point somewhere else
        WpApiClient.configure do |api_client|
          api_client.endpoint = imaginary_api_location
        end
        WpApiClient.get_client.get('custom_post_type')
      end
    end

    it "can specify whether or not to request embedded resources", vcr: {cassette_name: 'single_post', record: :new_episodes} do
      WpApiClient.configure do |api_client|
        api_client.embed = true
      end
      post = WpApiClient.get_client.get('posts/1')
      expect(post.embedded?).to be_truthy

      WpApiClient.configure do |api_client|
        api_client.embed = false
      end
      post = WpApiClient.get_client.get('posts/1')
      expect(post.embedded?).to be_falsy
    end
  end
end
