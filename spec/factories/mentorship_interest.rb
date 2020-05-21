FactoryBot.define do
  factory :mentorship_interest do
    association :user, factory: :user
    association :mentoring_interest, factory: :mentoring_interest
  end
end
