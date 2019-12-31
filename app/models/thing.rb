require_relative 'concerns/Protectable'

class Thing < ApplicationRecord
  include Protectable
  validates :name, :presence => true

  has_many :thing_images, inverse_of: :thing, dependent: :destroy
  scope :not_linked, ->(image) { where.not(:id => ThingImage.select(:thing_id).where(:image => image)) }
end
