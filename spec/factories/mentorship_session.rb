FactoryGirl.define do
  factory :mentorship_session do
    status {"scheduled"}
    association :mentorship,          factory: :mentorship
    association :mentoring_session,   factory: :mentoring_session
    attending {true}
  end
end
