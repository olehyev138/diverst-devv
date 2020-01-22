FactoryBot.define do
  factory :initiative_expense do
    initiative { FactoryBot.create(:initiative, :with_budget_item) }
    association :owner, factory: :user
    amount 0
  end
end
