FactoryBot.define do
  factory :budget do
    description { Faker::Lorem.sentence }
    association :group, factory: :group
    factory :approved_budget do
      after(:create) do |budget|
        budget.is_approved = true
        budget.budget_items.each { |bi| bi.approve! }
        budget.save
      end
    end

    after(:create) do |budget|
      create_list(:budget_item, 3, budget: budget)
    end
  end
end
