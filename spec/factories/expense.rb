FactoryGirl.define do
    factory :expense do
        association :enterprise, factory: :enterprise
        association :category, factory: :expense_category
        name {Faker::Name.name}
    end
end
