FactoryBot.define do
  factory :budget_user do
    association :budget_item
    budgetable { create(:initiative) }
  end
end
