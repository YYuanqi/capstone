FactoryBot.define do
  factory :image_content do
    content_type { "image/jpg" }
    content { Base64.encode64(ImageContentHelper.sample_image_file.read) }
  end
end
