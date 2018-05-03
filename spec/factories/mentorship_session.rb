FactoryGirl.define do
  factory :mentorship_session do
    association :user,                factory: :user
    association :mentoring_session,   factory: :mentoring_session
    attending {true}
  end
end
