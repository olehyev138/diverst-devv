FactoryBot.define do
  factory :mentorship_rating do
    rating 7
    association :user, factory: :user
    association :mentoring_session, factory: :mentoring_session
    comments { Faker::Lorem.sentence }
  end
end
