require_relative 'concerns/Protectable'

class Image < ApplicationRecord
  include Protectable

  attr_accessor :image_content

  has_many :thing_images, inverse_of: :image, dependent: :destroy
  has_many :things, through: :thing_images

  def basename
    caption || "image-#{id}"
  end
end
