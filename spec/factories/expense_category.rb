FactoryBot.define do
  factory :expense_category do
    name { Faker::Name.name }
    association :enterprise, factory: :enterprise
  end
end
