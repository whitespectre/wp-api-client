require 'webmock/rspec'

RSpec.describe WpApiClient::Configuration do
  describe "#configure" do

    before(:each) do
      WpApiClient.reset!
    end

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

    it "can specify whether or not to request embedded resources" do
      VCR.turned_off do

        WpApiClient.configure do |api_client|
          api_client.embed = false
        end

        # get an example API response and mock it
        resp = YAML.load(File.read 'spec/cassettes/single_post.yml')['http_interactions'][0]['response']['body']['string']
        ::WebMock.stub_request(:get,
          WpApiClient.configuration.endpoint + "/posts/1"
        ).to_return(
          body: resp,
          headers: {'Content-Type' => 'application/json'}
        )

        post = WpApiClient.get_client.get('posts/1')
      end
    end

    it "can set up OAuth credentials", vcr: {cassette_name: :oauth_test} do
      oauth_credentials = JSON.parse(File.read('config/oauth.json'), symbolize_names: true)

      WpApiClient.configure do |api_client|
        api_client.oauth_credentials = oauth_credentials
      end

      WpApiClient.get_client.get('posts/1')
    end

    it "can set up link relationships", vcr: {cassette_name: :single_post} do
      WpApiClient.configure do |api_client|
        api_client.define_mapping("http://my.own/mapping", :post)
      end

      post = WpApiClient.get_client.get('posts/1')
      expect { post.relations("http://my.own/mapping") }.not_to raise_error
    end
  end


end
