FactoryGirl.define do
  factory :mentorship_type do
    association :mentoring_type,  factory: :mentoring_type
    association :mentorship,      factory: :mentorship
  end
end
