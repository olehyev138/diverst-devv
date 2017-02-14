FactoryGirl.define do
  factory :department do
    enterprise
    name { Faker::Commerce.department }
  end
end
