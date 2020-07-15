FactoryBot.define do
  factory :mentorship_session do
    association :user,                factory: :user
    association :mentoring_session,   factory: :mentoring_session
    status { 'pending' }
    role { 'presenter' }
    factory :mentorship_session_skips_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
