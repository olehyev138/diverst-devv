FactoryBot.define do
  factory :annual_budget do
    association :group, factory: :group
    closed false

    after(:create) do |annual_budget|
      group = annual_budget.group

      annual_budget.amount = group&.annual_budget || 0
      annual_budget.approved_budget = group&.approved_budget || 0
      annual_budget.expenses = group&.spent_budget || 0
      annual_budget.leftover_money = group&.leftover_money || 0
      annual_budget.save
    end
  end
end
