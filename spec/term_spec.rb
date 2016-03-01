RSpec.describe WpApiClient::Entities::Term do
  describe "reading data out of the term", vcr: {cassette_name: 'single_term', record: :new_episodes} do

    before :each do
      @term = @api.get("categories/1")
    end

    it "returns the name" do
      expect(@term.name).to eq "Uncategorized"
    end

    it "returns the slug" do
      expect(@term.slug).to eq "uncategorized"
    end

    it "returns a taxonomy object" do
      expect(@term.taxonomy).to be_a WpApiClient::Entities::Taxonomy
    end

    it "returns an collection of posts" do
      expect(@term.posts).to be_a Hash
    end
  end

  describe "a term connected to two different post types",  vcr: {cassette_name: 'single_term', record: :new_episodes} do

    before :each do
      @term = @api.get("custom_taxonomy/2")
    end

    it "returns two collections of posts" do
      expect(@term.posts).to be_a Hash
    end
  end
end
