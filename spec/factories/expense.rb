FactoryBot.define do
  factory :expense do
    association :enterprise
    association :category, factory: :expense_category
    name { Faker::Lorem.sentence(3) }
    price 1000
  end
end
