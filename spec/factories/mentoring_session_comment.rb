FactoryBot.define do
  factory :mentoring_session_comment do
    association :user,                factory: :user
    association :mentoring_session,   factory: :mentoring_session
    content { Faker::Lorem.paragraph(2) }
  end
end
