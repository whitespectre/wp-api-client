RSpec.describe WpApiClient::Collection do
  describe "fetching posts concurrently", vcr: {cassette_name: 'concurrency', record: :new_episodes} do

    it "allows simultaneous fetching of posts" do
      resp = @api.concurrently do |api|
        api.get("posts/1")
        api.get("posts", page: 2)
      end
      expect(resp.first.title).to eq 'Hello world!'
      expect(resp.last.first.title).to eq 'Post 90'
    end
  end
end
