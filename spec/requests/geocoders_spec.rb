require 'rails_helper'

RSpec.describe 'Geocoders', type: :request do
  include_context 'db_cleanup'
  let(:jhu) { FactoryBot.build(:location, :jhu) }
  let(:address) { jhu.address }
  let(:position) { jhu.position }
  let(:search_address) { address.full_address.match("^(.*) #{address.zip}")[1] }
  let(:search_position) { position }
  let(:user) { signup FactoryBot.attributes_for(:user) }

  context 'geocoding' do
    let(:geocoder) { Geocoder.new }
    context 'service' do
      it 'locates location by address' do
        loc = geocoder.geocode search_address
        expect(loc.formatted_address).to eq(jhu.formatted_address)
        expect(loc.position === jhu.position).to be true
        expect(loc.address).to eq(jhu.address)
        expect(loc).to eq(jhu)
      end

      it 'locates location by position' do
        loc = geocoder.reverse_geocode search_position
        expect(loc.formatted_address).to eq(jhu.formatted_address)
        expect(loc.position == jhu.position).to be true
        expect(loc.address).to eq(jhu.address)
        expect(loc).to eq(jhu)
      end
    end
  end
end
