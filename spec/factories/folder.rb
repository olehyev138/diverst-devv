FactoryGirl.define do
  factory :folder do
    name {Faker::Name.name}
    association :enterprise, factory: :enterprise
  end
end
