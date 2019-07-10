require 'rails_helper'

RSpec.describe City, type: :model do

  it "created City will be persisted, have a name, and be found" do
    city = City.create(:name => "test");
    expect(city).to be_persisted;
    expect(city.name).to eq("test")
    expect(City.find(city.id)).to_not be_nil
  end
end

