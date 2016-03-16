RSpec.describe WpApiClient::Entities::Error do
  describe "an API access error", vcr: {cassette_name: 'single_post'} do

    Error_JSON = {"code"=>"rest_forbidden", "message"=>"You don't have permission to do this.", "data"=>{"status"=>403}}

    it "throws an exception" do
      expect {
        WpApiClient::Entities::Error.new(Error_JSON)
      }.to raise_error(WpApiClient::ErrorResponse)
    end

    it "recognises the error JSON exception" do
      expect(WpApiClient::Entities::Error.represents?(Error_JSON)).to be_truthy
    end

  end
end
