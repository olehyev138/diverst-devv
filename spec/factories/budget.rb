FactoryBot.define do
  factory :budget do
    transient do
      estimated_amount { nil }
    end

    description { Faker::Lorem.sentence }
    association :annual_budget, factory: :annual_budget
    factory :approved do
      after(:create) do |budget|
        budget.is_approved = true
        budget.budget_items.each { |bi| bi.approve! }
        budget.save
      end
    end

    trait :zero_budget do
      estimated_amount { 0 }
    end

    after(:create) do |budget, evaluator|
      evaluator.estimated_amount ?
          create_list(:budget_item, 3, budget: budget, estimated_amount: evaluator.estimated_amount) :
          create_list(:budget_item, 3, budget: budget)
    end
  end
end
