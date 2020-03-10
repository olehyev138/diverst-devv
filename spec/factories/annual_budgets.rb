FactoryBot.define do
  factory :annual_budget do
    association :group, factory: :group
    closed false
    amount 0
  end
end
