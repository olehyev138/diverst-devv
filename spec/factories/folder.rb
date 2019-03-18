FactoryBot.define do
  factory :folder do
    name {Faker::Name.name}
    group
    association :enterprise, factory: :enterprise
  end
end
