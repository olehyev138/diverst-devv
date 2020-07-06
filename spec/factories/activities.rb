FactoryBot.define do
  factory :activity do
    association :owner, factory: :user
  end
end
