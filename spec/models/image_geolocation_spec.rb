require 'rails_helper'

RSpec.describe 'ImageGeolocation', type: :model do
  include_context 'db_cleanup'

  context 'properties' do
    subject { FactoryBot.build(:image) }
    it { expect(subject).to respond_to(:lng) }
    it { expect(subject).to respond_to(:lat) }
    it { expect(subject.save).to be(true) }
  end

  context 'image factory' do
    include_context 'db_clean_after'
    subject { FactoryBot.create(:image, lng: -76.613111, lat: 39.285848) }
    it { expect(Image.where(lng: subject.lng, lat: subject.lat).exists?).to be true }
  end

  context 'Point' do
    subject { FactoryBot.build(:point) }
    it { expect(subject).to respond_to(:lng) }
    it { expect(subject).to respond_to(:lat) }
    it { expect(subject).to respond_to(:==) }
    it { expect(subject.latlng).to eq([subject.lat, subject.lng]) }
    it { expect(subject.lnglat).to eq([subject.lng, subject.lat]) }
  end

  context 'Image composed_of position' do
    let(:point) { FactoryBot.build(:point) }
    subject { FactoryBot.create(:image, position: point) }
    it { expect(subject).to respond_to(:position) }
    it { expect(Image.find(subject.id).position.lng).to eq(subject.lng) }
    it { expect(Image.find(subject.id).position.lat).to eq(subject.lat) }
  end
end
