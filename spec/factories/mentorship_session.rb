FactoryBot.define do
  factory :mentorship_session do
    association :user,                factory: :user
    association :mentoring_session,   factory: :mentoring_session
    status { 'pending' }
    role { 'presenter' }
  end
end
