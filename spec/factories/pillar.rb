FactoryBot.define do
  factory :pillar do
    name { Faker::Commerce.product_name }
  end
end
