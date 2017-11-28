FactoryGirl.define do
  factory :poll do
    title { Faker::Lorem.sentence(3) }
    description { Faker::Lorem.sentence }
    email_sent false
    nb_invitations 10
    enterprise
    association :owner, factory: :user

    factory :poll_with_responses do
      transient do
        response_count 10
      end

      after(:create) do |poll, evaluator|
        evaluator.responses create_list(:poll_response, evaluator.response_count, poll: poll)
      end
    end
  end
end
