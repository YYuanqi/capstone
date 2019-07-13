require 'rails_helper'

describe City, type: :model do
  include_context "db_cleanup", :transaction
  before(:all) do
    @city=City.create(:name=>"test")
  end
  let(:city) { City.find(@city.id) }

  context "created city (let)" do
    it { expect(city).to be_persisted }
    it { expect(city.name).to eq("test") }
    it { expect(City.find(city.id)).to_not be_nil }
  end

  context "created city (subject)" do
    subject { @city }

    it { is_expected.to be_persisted }
    it { expect(subject.name).to eq("test") }
    it { expect(City.find(subject.id)).to_not be_nil }
  end
end
