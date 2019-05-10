FactoryBot.define do
  factory :poll do
    title { Faker::Lorem.sentence(3) }
    description { Faker::Lorem.sentence }
    email_sent false
    nb_invitations 10
    enterprise
    association :owner, factory: :user

    after(:build) do |poll|
      poll.fields.build({ type: 'SelectField', title: 'What is 1 + 1?', options_text: "1\r\n2\r\n3\r\n4\r\n5\r\n6\r\n7" })
    end

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
