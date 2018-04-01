FactoryGirl.define do
  factory :mentorship do
      association :user, factory: :user
      description { Faker::Lorem.sentence }
  end
end
