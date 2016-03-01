RSpec.describe WpApiClient::Entities::Term do
  describe "reading data out of the term", vcr: {cassette_name: 'single_term', record: :new_episodes} do

    before :each do
      @term = @api.get("custom_taxonomy/2")
    end

    it "returns the name" do
      expect(@term.name).to eq "term_one"
    end

    it "returns the slug" do
      expect(@term.slug).to eq "term_one"
    end

    it "returns a taxonomy object" do
      expect(@term.taxonomy).to be_a WpApiClient::Entities::Taxonomy
    end

    it "returns its posts" do
      expect(@term.posts).to be_a WpApiClient::Collection
    end

    it "accepts a post type argument for its posts" do
      expect(@term.posts("custom_post_type")).to be_a WpApiClient::Collection
    end
  end
end
