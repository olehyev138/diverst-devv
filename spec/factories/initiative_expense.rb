FactoryBot.define do
  factory :initiative_expense do
    association :initiative
    association :owner, factory: :user
    annual_budget
    amount 0
  end
end
