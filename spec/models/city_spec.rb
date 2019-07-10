require 'rails_helper'

RSpec.describe City, type: :model do

  context "create City" do
    before(:each) do
      @city = City.create(:name => "test")
    end
    
    after(:each) do
      @city.delete
    end
    
    it "will be persisted, have a name, and be found" do
      expect(@city).to be_persisted;
      expect(@city.name).to eq("test")
      expect(City.find(@city.id)).to_not be_nil
    end
  end
end

