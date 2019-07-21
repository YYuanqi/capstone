class Thing < ApplicationRecord
  validates :name, :presence => true

  has_many :thing_images, inverse_of: :thing, dependent: :destroy
end
