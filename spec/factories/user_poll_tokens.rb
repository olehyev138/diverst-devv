FactoryBot.define do
  factory :user_poll_token do
    association :user, factory: :user
    association :poll, factory: :poll
    email_sent false
    submitted false
    cancelled false
  end
end
