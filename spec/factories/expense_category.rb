FactoryGirl.define do
    factory :expense_category do
        name {Faker::Name.name}
    end
end
