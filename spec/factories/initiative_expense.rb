FactoryGirl.define do
  factory :initiative_expense do
    association :initiative
    association :owner, factory: :user
    amount 1000
  end
end
