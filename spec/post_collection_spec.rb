RSpec.describe WpApiClient::Collection do
  describe "fetching posts of a certain post type", vcr: {cassette_name: 'custom_post_type_collection', record: :new_episodes} do

    before :each do
      @collection = @api.get("custom_post_type")
    end

    it "returns an array of posts" do
      expect(@collection.first).to be_a WpApiClient::Entities::Post
    end

    it "can paginate" do
      expect(@collection.count).to eq 10
      paged_id = @collection.first.id

      @next_page = @api.get(@collection.next_page)
      expect(@next_page.first.id).to eq (paged_id - 10)

      @previous_page = @api.get(@next_page.previous_page)
      expect(@previous_page.first.id).to eq paged_id

      # no pages left to turn
      expect(@previous_page.previous_page).to eq nil
    end
  end
end
