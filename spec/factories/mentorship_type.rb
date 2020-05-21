FactoryBot.define do
  factory :mentorship_type do
    association :mentoring_type, factory: :mentoring_type
    association :user, factory: :user
  end
end
