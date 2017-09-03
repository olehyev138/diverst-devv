FactoryGirl.define do
  factory :expense_category do
    association :enterprise
    name { Faker::Lorem.sentence(3) }
  end
end
