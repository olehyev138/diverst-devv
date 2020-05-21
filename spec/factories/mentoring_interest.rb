FactoryBot.define do
  factory :mentoring_interest do
    name { Faker::Commerce.unique.department }
  end
end
