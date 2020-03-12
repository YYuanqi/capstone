FactoryBot.define do
  factory :point do
    transient do
      lng { Faker::Number.negative(-77.0, 76.0).round(6) }
      lat { Faker::Number.negative(38.7, 39.7).round(6) }
    end
    initialize_with { Point.new(lng, lat) }

    trait :jhu do
      lng { -76.620464 }
      lng { 39.3304957 }
    end
  end

  factory :postal_address do
    transient do
      sequence(:street_address) { |idx| "#{3000 + idx} North Charles Street" }
      city { 'Baltimore' }
      state_code { 'MD' }
      zip { '21218' }
      country_code { 'US' }
    end

    initialize_with { PostAddress.new(street_address, city, state_code, zip, country_code) }

    trait :jhu do
      street_address { '3400 North Charles Street' }
      city { 'Baltimore' }
      state_code { 'MD' }
      zip { '21218' }
      country_code { 'US' }
    end
  end

  factory :location do
    address { FactoryBot.build(:postal_address) }
    position { FactoryBot.build(:point) }
    formatted_address {
      street_no = address.street_address.match(/^(\d+)/)[1]
      "#{street_no} N Charles St, Baltimore, MD 21218, USA"
    }
    initialize_with { Location.new(formmated_address, position, address) }

    trait :jhu do
      address { FactoryBot.build(:postal_address, :jhu) }
      position { FactoryBot.build(:postal, :jhu) }
    end
  end
end
