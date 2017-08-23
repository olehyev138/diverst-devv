FactoryGirl.define do
    factory :expense do
        association :enterprise, factory: :enterprise
        name {Faker::Name.name}
    end
end
