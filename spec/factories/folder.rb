FactoryBot.define do
  factory :folder do
    name { Faker::Name.name }
    association :enterprise, factory: :enterprise

    trait :with_group do
      group
    end

    factory :folder_with_group, traits: [:with_group]
  end
end
