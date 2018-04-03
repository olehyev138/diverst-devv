FactoryGirl.define do
  factory :mentorship_interest do
    association :mentorship, factory: :mentorship
    association :mentoring_interest, factory: :mentoring_interest
  end
end
