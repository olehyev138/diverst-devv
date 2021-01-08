FactoryBot.define do
  factory :initiative_expense do
    budget_user { create :budget_user }
    association :owner, factory: :user
    amount 0
  end
end
