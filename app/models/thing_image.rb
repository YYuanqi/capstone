class ThingImage < ApplicationRecord
  belongs_to :image
  belongs_to :thing

  validates :image, :thing, presence: true
end
