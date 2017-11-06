FactoryGirl.define do
  factory :folder do
    name {Faker::Name.name}
    association :container, factory: :enterprise
  end
end
