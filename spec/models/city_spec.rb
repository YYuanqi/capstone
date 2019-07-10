require 'rails_helper'

RSpec.describe City, type: :model do

  context "valid city" do
    it "has a name" do
      city = City.create(:name=>"text")
      expect(city).to be_valid
      expect(city.name).to_not be_nil      
    end
  end
end

