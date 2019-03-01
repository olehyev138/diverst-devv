FactoryBot.define do
  factory :mentoring_session_topic do
    association :mentoring_interest,  factory: :mentoring_interest
    association :mentoring_session,   factory: :mentoring_session
  end
end
