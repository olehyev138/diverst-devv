FactoryBot.define do
  factory :initiative_expense do
    association :initiative
    association :owner, factory: :user
    amount 0
  end
end
