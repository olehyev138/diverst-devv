FactoryBot.define do
  factory :budget do
    transient do
      estimated_amount { nil }
      number_of_items { 3 }
    end

    description { Faker::Lorem.sentence }
    association :annual_budget, factory: :annual_budget
    factory :approved_budget do
      after(:create) do |budget|
        budget.is_approved = true
        budget.save
      end
    end

    trait :zero_budget do
      estimated_amount { 0 }
    end

    after(:build) do |budget, evaluator|
      if budget.budget_items.blank?
        evaluator.estimated_amount ?
            budget.budget_items = build_list(:budget_item, evaluator.number_of_items, budget: nil, estimated_amount: evaluator.estimated_amount) :
            budget.budget_items = build_list(:budget_item, evaluator.number_of_items, budget: nil)
      end
    end
  end
end
