RSpec.describe WpApiClient::Entities::Image do
  describe "calling instance methods on an image object", vcr: {cassette_name: 'single_image'} do

    before :each do
      @image = @api.get("media/203")
    end

    it "returns the URL for different sizes" do
      expect(@image.sizes(:thumbnail)).to be_a_url
      expect(@image.sizes(:full)).to be_a_url
      expect(@image.sizes(:not_a_real_size)).to be_nil
    end
  end
end
