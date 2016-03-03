RSpec.describe WpApiClient::Relationship do
  describe "relationships with terms", vcr: {cassette_name: 'single_post'} do
    before :each do
      post = @api.get("posts/1")
      @relationship = WpApiClient::Relationship.new(@api, post.resource, "https://api.w.org/term")
    end

    it "presents term objects as a set of key/value collections" do
      relations = @relationship.get_relations
      expect(relations).to be_a Hash
      expect(relations["category"]).to be_a WpApiClient::Collection
    end
  end

  describe "relationships with posts", vcr: {cassette_name: 'single_term'} do
    before :each do
      term = @api.get("categories/1")
      @relationship = WpApiClient::Relationship.new(@api, term.resource, "http://api.w.org/v2/post_type")
    end

    it "returns an collection of posts" do
      relations = @relationship.get_relations
      expect(relations).to be_a Hash
      expect(relations["posts"]).to be_a WpApiClient::Collection
    end
  end

  describe "relationships with metadata", vcr: {cassette_name: 'single_post', record: :new_episodes} do
    before :each do
      # we need oAuth for this
      oauth_credentials = JSON.parse(File.read('config/oauth.json'), symbolize_names: true)
      WpApiClient.configure do |api_client|
        api_client.oauth_credentials = oauth_credentials
      end
      @api = WpApiClient.get_client
      post = @api.get("posts/1")
      @relationship = WpApiClient::Relationship.new(@api, post.resource, "https://api.w.org/meta")
    end

    it "returns an hash of meta" do
      relations = @relationship.get_relations
      expect(relations).to be_a Hash
      expect(relations["example_metadata_field"]).to be_a String
    end
  end

  describe "defining a new relationship" do

    it "permits new relationships to be defined", vcr: {cassette_name: 'single_post'} do
      WpApiClient::Relationship.define("https://my.new/relationship", :post)
      post = @api.get("posts/1")
      @relationship = WpApiClient::Relationship.new(@api, post.resource, "https://my.new/relationship")
    end
  end

end
