FactoryBot.define do
  factory :poll_response do
    poll
    user
    anonymous true
  end
end
