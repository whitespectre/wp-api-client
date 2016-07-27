RSpec.describe WpApiClient::Entities::User do
  describe "calling instance methods on a user", vcr: {cassette_name: 'single_user'} do
    before :each do
      @user = @api.get("users/1")
    end

    it "returns the id" do
      expect(@user.id).to eq 1
    end
  end
end
