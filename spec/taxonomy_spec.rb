RSpec.describe WpApiClient::Entities::Taxonomy do
  describe "calling instance methods on a taxonomy", vcr: {cassette_name: 'single_taxonomy', record: :new_episodes} do

    before :each do
      @taxonomy = @api.get("taxonomies/custom_taxonomy")
    end

    it "returns the name" do
      expect(@taxonomy.name).to eq "Custom taxonomy"
    end

    it "returns a collection of terms" do
      expect(@taxonomy.terms.first.name).to be_a String
    end
  end
end
