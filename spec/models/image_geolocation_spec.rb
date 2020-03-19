require 'rails_helper'

RSpec.describe "Image Geolocation", type: :model do
  include_context "db_cleanup"

  context "properties" do
    subject { FactoryBot.build(:image) }
    it { expect(subject).to respond_to(:lng) }
    it { expect(subject).to respond_to(:lat) }
    it { expect(subject.save).to be true }

    context "image factory" do
      include_context "db_clean_after"
      subject { FactoryBot.create(:image, lng: -76.613111, lat: 39.285848) }
      it { expect(Image.where(lng: subject.lng, lat: subject.lat).exists?).to be true }
    end
  end

  context "Point" do
    subject { FactoryBot.build(:point) }
    it { expect(subject).to respond_to(:lng) }
    it { expect(subject).to respond_to(:lat) }
    it { expect(subject).to respond_to(:==) }
    it { expect(subject.latlng).to eq([subject.lat, subject.lng]) }
    it { expect(subject.lnglat).to eq([subject.lng, subject.lat]) }
  end

  context "Image composed_of position" do
    let(:point) { FactoryBot.build(:point) }
    subject { FactoryBot.create(:image, position: point) }
    it { expect(subject).to respond_to(:position) }
    it { expect(Image.find(subject.id).position.lng).to eq(subject.lng) }
    it { expect(Image.find(subject.id).position.lat).to eq(subject.lat) }
  end

  context "Images within distance of Point" do
    include_context "db_clean_all"
    let(:origin) { Image.where(:lat => 0.0).first }
    before(:all) do
      (0..90).each do |idx|
        point = Point.new(0, 90 - idx)
        FactoryBot.create(:image, :image_content => nil, :position => point)
      end
    end

    it "finds closest" do
      closest = Image.closest(:origin => origin).where.not(:id => origin)
      expect(closest.first).to eql(Image.where(:lat => 1.0).first)
    end

    it "finds within range" do
      range = Image.within(13 * 69, :origin => origin).where.not(:id => origin)
      expect(range.count).to eq(13 - 1) # excluded the origin
      range.each { |img| expect(img.distance_from(origin)).to be <= 13 * 69 }
    end

    it "finds within range ordered" do
      range = Image.within(13 * 69, :origin => origin).by_distance(:origin => origin)
      last_distance = 0
      range.each do |img|
        expect(distance = img.distance_from(origin)).to be <= 13 * 69
        expect(last_distance).to be <= distance
        last_distance = distance
      end
    end

    it "finds within range annotated with distance" do
      range = Image.within(13 * 69, :origin => origin).where.not(:id => origin)
      DistanceCollection.new(range).set_distance_from(origin)
      range.each do |img|
        expect(img).to respond_to(:distance)
        expect(img.distance).to be <= 13 * 69
      end
    end
  end

  context "ThingImage geolocation thru Image" do
    include_context "db_clean_all"
    let(:origin) { Image.where(:lat => 0.0).first }
    before(:all) do
      (0..90).each do |idx|
        thing = FactoryBot.create(:thing)
        point = Point.new(0, 90 - idx)
        image = FactoryBot.create(:image, :image_content => nil, :position => point)
        FactoryBot.create(:thing_image, :thing => thing, :image => image,
                          :priority => idx % 2)
      end
    end

    it "finds ThingImage with near Images" do
      near = ThingImage.eager_load(:image).within(10 * 69, :origin => origin)
      expect(near.size).to be(10)
      near.each do |ti|
        expect(ti.image.distance_from(origin)).to be <= 10 * 69
      end
    end

    it "finds ThingImage with near Images with distance" do
      near = ThingImage.select("thing_images.*")
               .select("images.lat, images.lng")
               .joins(:image)
               .within(10 * 69, :origin => origin)
      DistanceCollection.new(near).set_distance_from(origin)
      expect(near.size).to be(10)
      near.each do |ti|
        expect(ti).to respond_to(:distance)
        expect(ti.distance).to be <= 10 * 69
      end
    end

    it "finds Thing near primary Image" do
      #establish expected result
      primary_in_range = 0;
      ThingImage.all.each { |ti|
        if (ti.priority == 0 && ti.image.distance_from(origin) <= 10 * 69)
          primary_in_range += 1
        end
      }
      expect(primary_in_range).to be <= ThingImage.count / 2

      near = ThingImage.joins(:image)
               .within(10 * 69, :origin => origin)
               .where(:priority => 0)
      expect(near.where(:priority => 0).size).to be(primary_in_range)
      expect(near.primary).to_not be_nil
    end
  end
end
