FactoryBot.define do
  factory :poll_response do
    poll
    user
    anonymous false

    trait :anonymous do
      anonymous true
    end
  end
end
