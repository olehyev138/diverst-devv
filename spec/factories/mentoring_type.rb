FactoryBot.define do
  factory :mentoring_type do
    name { Faker::Space.unique.moon }
  end
end
