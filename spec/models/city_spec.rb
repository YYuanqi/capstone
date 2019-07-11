require 'rails_helper'

RSpec.describe City, type: :model do
  include_context "db_cleanup", :transaction
  include_context "db_scope"

  context "create City" do
    let(:city) { City.create(:name => "test") }
    
    it "will be persist" do
      expect(city).to be_persisted
    end
    
    it "have a name" do
      expect(city.name).to eq("test")
    end
    
    it "will be found" do
      expect(City.find(city.id)).to_not be_nil
    end
  end
end

