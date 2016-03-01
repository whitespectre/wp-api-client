RSpec.describe WpApiClient::Entities::Post do
  describe "calling instance methods on a post", vcr: {cassette_name: 'single_post'} do

    before :each do
      @post = @api.get("posts/1")
    end

    it "returns the title" do
      expect(@post.title).to eq "Hello world!"
    end

    it "returns the date as a Time object" do
      expect(@post.date).to be_a Time
    end

    it "returns the content as HTML" do
      expect(@post.content).to eq "<p>Welcome to WordPress. This is your first post. Edit or delete it, then start writing!</p>\n"
    end

    it "returns its own ID" do
      expect(@post.id).to eq 1
    end

    it "returns an array of Term objects" do
      expect(@post.terms).to be_an Array
      expect(@post.terms.first).to be_a WpApiClient::Entities::Term
    end
  end
end
